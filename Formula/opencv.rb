# opencv: Build a bottle for Linux
class Opencv < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/4.2.0.tar.gz"
  sha256 "9ccb2192d7e8c03c58fee07051364d94ed7599363f3b0dce1c5e6cc11c1bb0ec"

  bottle do
    sha256 "f53dd07aea7163aff1d30ec9cd6b4d2a49db5362e5845b690284b4f0574f09db" => :catalina
    sha256 "081a75f753ede6ec73bb27135838fee1b9f15660663cae350e2f37a988498529" => :mojave
    sha256 "4c6deb39336b29bf1bb3f8acd5adbb26a8dc9ac8b56beb991bd720e6ce0b6966" => :high_sierra
    sha256 "acebe63fad98afcea1aeb1231254b25728460a446e48d2f93af9649ee55de6a8" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "glog"
  depends_on "harfbuzz"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "python"
  depends_on "tbb"
  uses_from_macos "openblas"

  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/4.2.0.tar.gz"
    sha256 "8a6b5661611d89baa59a26eb7ccf4abb3e55d73f99bb52d8f7c32265c8a43020"
  end

  def install
    ENV.cxx11
    dylib = OS.mac? ? "dylib" : "so"

    resource("contrib").stage buildpath/"opencv_contrib"

    # Reset PYTHONPATH, workaround for https://github.com/Homebrew/homebrew-science/pull/4885
    ENV.delete("PYTHONPATH")

    py3_config = `python3-config --configdir`.chomp
    py3_include = `python3 -c "import distutils.sysconfig as s; print(s.get_python_inc())"`.chomp
    py3_version = Language::Python.major_minor_version "python3"

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=ON
      -DBUILD_OPENEXR=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_PNG=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_opencv_hdf=OFF
      -DBUILD_opencv_java=OFF
      -DBUILD_opencv_text=ON
      -DOPENCV_ENABLE_NONFREE=ON
      -DOPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules
      -DOPENCV_GENERATE_PKGCONFIG=ON
      -DWITH_1394=OFF
      -DWITH_CUDA=OFF
      -DWITH_EIGEN=ON
      -DWITH_FFMPEG=ON
      -DWITH_GPHOTO2=OFF
      -DWITH_GSTREAMER=OFF
      -DWITH_JASPER=OFF
      -DWITH_OPENEXR=ON
      -DWITH_OPENGL=OFF
      -DWITH_QT=OFF
      -DWITH_TBB=ON
      -DWITH_VTK=OFF
      -DBUILD_opencv_python2=OFF
      -DBUILD_opencv_python3=ON
      -DPYTHON3_EXECUTABLE=#{which "python3"}
      -DPYTHON3_LIBRARY=#{py3_config}/libpython#{py3_version}.#{dylib}
      -DPYTHON3_INCLUDE_DIR=#{py3_include}
    ]
    args << "-DENABLE_PRECOMPILED_HEADERS=OFF" unless OS.mac?

    # The compiler on older Mac OS cannot build some OpenCV files using AVX2
    # extensions, failing with errors such as
    # "error: use of undeclared identifier '_mm256_cvtps_ph'"
    # Work around this by not trying to build AVX2 code.
    if MacOS.version <= :yosemite
      args << "-DCPU_DISPATCH=SSE4_1,SSE4_2,AVX"
    end

    args << "-DENABLE_AVX=OFF" << "-DENABLE_AVX2=OFF"
    unless MacOS.version.requires_sse42?
      args << "-DENABLE_SSE41=OFF" << "-DENABLE_SSE42=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      system "make"
      lib.install Dir["lib/*.a"]
      lib.install Dir["3rdparty/**/*.a"]
      rm lib/"libIlmImf.a"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opencv2/opencv.hpp>
      #include <iostream>
      int main() {
        std::cout << CV_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/opencv4",
                    "-o", "test"
    assert_equal `./test`.strip, version.to_s

    output = shell_output("python3 -c 'import cv2; print(cv2.__version__)'")
    assert_equal version.to_s, output.chomp
  end
end
