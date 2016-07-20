# gmp: Build a bottle for Linuxbrew
class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.1.tar.xz"
  sha256 "d36e9c05df488ad630fff17edb50051d6432357f9ce04e34a09b3d818825e831"

  bottle do
    cellar :any
    sha256 "4677ee116d69d5959b46668f3e4eacc4af8dbae1ff411fd278d41a1ccdad0046" => :x86_64_linux
  end

  option "32-bit"
  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    args = ["--prefix=#{prefix}", "--enable-cxx"]

    if build.build_32_bit?
      ENV.m32
      args << "ABI=32"
    end

    # https://github.com/Homebrew/homebrew/issues/20693
    args << "--disable-assembly" if build.build_32_bit? || build.bottle?

    system "./configure", *args
    system "make"
    system "make", "check" unless OS.linux? # Fails without LD_LIBRARY_PATH
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gmp.h>

      int main()
      {
        mpz_t integ;
        mpz_init (integ);
        mpz_clear (integ);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"
  end
end
