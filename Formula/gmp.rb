class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
  sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"

  bottle do
    cellar :any
    rebuild 1
    sha256 "28f32f9fc480626b159404d33b8a0ecba55e6a19ecbc1effc4426086b1ade10c" => :x86_64_linux
  end

  depends_on "m4" => :build unless OS.mac?

  option :cxx11

  env :super if OS.linux?

  def install
    ENV.cxx11 if build.cxx11?
    args = %W[--prefix=#{prefix} --enable-cxx]

    if OS.mac?
      args << "--build=core2-apple-darwin#{`uname -r`.to_i}" if build.bottle?
    else
      args << "--build=core2-linux-gnu" if build.bottle?
      args << "ABI=32" if Hardware::CPU.intel? && Hardware::CPU.is_32_bit?
    end

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gmp.h>
      #include <stdlib.h>

      int main() {
        mpz_t i, j, k;
        mpz_init_set_str (i, "1a", 16);
        mpz_init (j);
        mpz_init (k);
        mpz_sqrtrem (j, k, i);
        if (mpz_get_si (j) != 5 || mpz_get_si (k) != 1) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"
  end
end
