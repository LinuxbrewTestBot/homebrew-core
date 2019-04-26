# kyoto-cabinet: Build a bottle for Linuxbrew
class KyotoCabinet < Formula
  desc "Library of routines for managing a database"
  homepage "https://fallabs.com/kyotocabinet/"
  url "https://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.77.tar.gz"
  sha256 "56899329384cc6f0f1f8aa3f1b41001071ca99c1d79225086a7f3575c0209de6"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    sha256 "ddd2f1b0f1985ad81b04b29dbd54f95c5f7c88f7427b559e9f298a6473a820b0" => :mojave
    sha256 "e4b99c22b5aebf85986e5c172ec61768833708acbb04318335f6641bea1f77ef" => :high_sierra
    sha256 "04ef198a6638dabdee27e881df9b16970eadc724f2f663a01edee7950b38b85a" => :sierra
    sha256 "689642bef7edccdea636d2502985143a0b5a31dd1b76bc07625977b9f82ecc8c" => :x86_64_linux
  end

  patch :DATA

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", *("--disable-zlib" unless OS.mac?)
    system "make" # Separate steps required
    system "make", "install"
  end
end


__END__
--- a/kccommon.h  2013-11-08 09:27:37.000000000 -0500
+++ b/kccommon.h  2013-11-08 09:27:47.000000000 -0500
@@ -82,7 +82,7 @@
 using ::snprintf;
 }

-#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER)
+#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER) || defined(_LIBCPP_VERSION)

 #include <unordered_map>
 #include <unordered_set>
