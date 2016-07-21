class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "http://www.hyperrealm.com/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/v1.6.tar.gz"
  sha256 "18739792eb463d73525d7aea9b0a48b14106fae1cfec09aedc668d8c1079adf1"

  bottle do
    cellar :any
    sha256 "4c66dc28067e2413541c79addf46cdc2def7d9537536c0f8a56b174e0644ec7d" => :x86_64_linux
  end

  head do
    url "https://github.com/hyperrealm/libconfig.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "flex" => :build unless OS.mac?
  depends_on "texinfo" => :build unless OS.mac?

  def install
    ENV.universal_binary if build.universal?

    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"

    # Fixes "scanner.l:137:59: error: too few arguments to function call ..."
    # Forces regeneration of the BUILT_SOURCES "scanner.c" and "scanner.h"
    # Reported 6 Jun 2016: https://github.com/hyperrealm/libconfig/issues/66
    touch "lib/scanner.l"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libconfig.h>
      int main() {
        config_t cfg;
        config_init(&cfg);
        config_destroy(&cfg);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}",
           testpath/"test.c", "-lconfig", "-o", testpath/"test"
    system "./test"
  end
end
