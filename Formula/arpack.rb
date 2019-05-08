# arpack: Build a bottle for Linuxbrew
class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.7.0.tar.gz"
  sha256 "972e3fc3cd0b9d6b5a737c9bf6fd07515c0d6549319d4ffb06970e64fa3cc2d6"
  revision 1
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    sha256 "4306c3774d728832adb5b6bb7cc05fb44e57dde89e61dcef7d3bdcc18c22cd7f" => :mojave
    sha256 "03e93ab382084b1514e343056c0fcc95083488ea920f13b74a8ce1dcc5f6a88c" => :high_sierra
    sha256 "0403f41ead18bc24b11078a5dbaea2f8888d2035a0b8b4f1830ef757e7737fab" => :sierra
    sha256 "42b6827a4424573bc9263012447ef136087a13d18ed9ad5b5650a1d9d3df97c4" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "veclibfort" if OS.mac?
  depends_on "openblas" unless OS.mac?

  def install
    args = %W[ --disable-dependency-tracking
               --prefix=#{libexec} ]
    if OS.mac?
      args << "--with-blas=-L#{Formula["veclibfort"].opt_lib}\ -lvecLibFort"
    else
      args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas"
    end

    args << "F77=mpif77" << "--enable-mpi"

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f",
                     "TESTS/mmio.f", "TESTS/debug.h"
    (libexec/"bin").install (buildpath/"PARPACK/EXAMPLES/MPI").children
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                       "-L#{lib}", "-larpack",
                       *("-L#{Formula["veclibfort"].opt_lib}" if OS.mac?), *("-lvecLibFort" if OS.mac?),
                       *("-lopenblas" unless OS.mac?)
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")
  end
end
