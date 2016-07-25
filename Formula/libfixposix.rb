class Libfixposix < Formula
  desc "Thin wrapper over POSIX syscalls"
  homepage "https://github.com/sionescu/libfixposix"
  url "https://github.com/sionescu/libfixposix/releases/download/v0.4.1/libfixposix-0.4.1.tar.gz"
  sha256 "38b111111d87f87e5c53a207effb25e5a86b5879770dcd8cf4f38e440620e6d5"

  bottle do
    cellar :any
    sha256 "ca479c6bf373017e6414a61ecc44a67138cdf40290f71db8c0e69555a648e31a" => :x86_64_linux
  end

  head do
    url "https://github.com/sionescu/libfixposix.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"mxstemp.c").write <<-EOS.undent
      #include <stdio.h>

      #include <lfp.h>

      int main(void)
      {
          fd_set rset, wset, eset;
          unsigned i;

          lfp_fd_zero(&rset);
          lfp_fd_zero(&wset);
          lfp_fd_zero(&eset);

          for(i = 0; i < FD_SETSIZE; i++) {
              if(lfp_fd_isset(i, &rset)) {
                  printf("%d ", i);
              }
          }

          return 0;
      }
    EOS
    system ENV.cc, "mxstemp.c", lib/"libfixposix.#{OS.mac? ? "dylib" : "so"}", "-I#{include}", "-L#{lib}", "-o", "mxstemp"
    system "./mxstemp"
  end
end
