# openjpeg: Build a bottle for Linuxbrew
class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.3.1.tar.gz"
  sha256 "63f5a4713ecafc86de51bfad89cc07bb788e9bba24ebbf0c4ca637621aadb6a9"
  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    sha256 "6de317bfef3ab808ff5f3eb9c1aa47f77e7236fba8ad0d606b29b38eb47c321e" => :mojave
    sha256 "1eb8b2f698ecf16196e06a2d9f7ba20eb7f0ba447d351e36eb3344d3ed6c5c58" => :high_sierra
    sha256 "d2b377424ff5387892bc1af653654fdcc70702e4524f3309b3f0874ac6e2d84c" => :sierra
    sha256 "33168cda26238c22f4c307229c743213a893c984f3815dd8f329e741aa108180" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_DOC=ON"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <openjpeg.h>

      int main () {
        opj_image_cmptparm_t cmptparm;
        const OPJ_COLOR_SPACE color_space = OPJ_CLRSPC_GRAY;

        opj_image_t *image;
        image = opj_image_create(1, &cmptparm, color_space);

        opj_image_destroy(image);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include.children.first}",
           testpath/"test.c", "-L#{lib}", "-lopenjp2", "-o", "test"
    system "./test"
  end
end
