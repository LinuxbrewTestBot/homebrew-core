# cfitsio: Build a bottle for Linuxbrew
class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3440.tar.gz"
  version "3.440"
  sha256 "dd1cad4208fb7a9462914177f26672ccfb21fc8a1f6366e41e7b69b13ad7fd24"

  bottle do
    cellar :any
    sha256 "c24b1689d523dd1503c8bf4357fa4995154fa81af3d79e739eb8de4c75be4687" => :x86_64_linux
  end

  option "with-reentrant", "Build with support for concurrency"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-reentrant" if build.with? "reentrant"
    system "./configure", *args
    system "make", "shared"
    system "make", "install"
    (pkgshare/"testprog").install Dir["testprog*"]
  end

  test do
    cp Dir["#{pkgshare}/testprog/testprog*"], testpath
    system ENV.cc, "testprog.c", "-o", "testprog", "-I#{include}",
                   "-L#{lib}", "-lcfitsio"
    system "./testprog > testprog.lis"
    cmp "testprog.lis", "testprog.out"
    cmp "testprog.fit", "testprog.std"
  end
end
