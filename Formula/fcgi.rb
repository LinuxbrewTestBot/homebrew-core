# fcgi: Build a bottle for Linux
class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # Last known good original homepage: https://web.archive.org/web/20080906064558/www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://downloads.sourceforge.net/project/slackbuildsdirectlinks/fcgi/fcgi-2.4.0.tar.gz"
  mirror "https://fossies.org/linux/www/old/fcgi-2.4.0.tar.gz"
  mirror "https://ftp.gwdg.de/pub/linux/gentoo/distfiles/fcgi-2.4.0.tar.gz"
  sha256 "66fc45c6b36a21bf2fbbb68e90f780cc21a9da1fffbae75e76d2b4402d3f05b9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "54cfcdd18d640c947dca6c7d02eec6ef996ed6abd1cce93ec6d2265da7c56415" => :catalina
    sha256 "022ad3910de37e2713d9795bff3fc89d4562e4eeea218e9985023515478b980f" => :mojave
    sha256 "e3916280d172a68bd76bb57d6799e7557a5b0933949403cefd35ec722da89889" => :high_sierra
    sha256 "252079a683b54fa08771bdcdc6a92e1c83f186361690e6e21674b4efdb9192b6" => :x86_64_linux
  end

  # Fixes "dyld: Symbol not found: _environ"
  # Affects programs linking this library. Reported at
  # https://fastcgi-developers.fastcgi.narkive.com/Kowew8bW/patch-for-symbol-not-found-environ-on-mac-os-x
  # https://trac.macports.org/browser/trunk/dports/www/fcgi/files/patch-libfcgi-fcgi_stdio.c.diff
  patch :DATA

  unless OS.mac?
    patch do
      # Fix: fcgio.cpp:50:14: error: 'EOF' was not declared in this scope
      url "https://gist.githubusercontent.com/iMichka/f635b126d66d9d1161ed99d62f2b7a14/raw/c7e71898cc00edf4af67638d58d458c211e61176/fcgi?full_index=1"
      sha256 "d4e088c96b5944bd137033ffff9d9291b3fad2c5b03ca7623b4ab0ff3deb4407"
    end
  end

  def install
    ENV.deparallelize unless OS.mac?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"testfile.c").write <<~EOS
      #include "fcgi_stdio.h"
      #include <stdlib.h>
      int count = 0;
      int main(void){
        while (FCGI_Accept() >= 0){
        printf("Request number %d running on host %s", ++count, getenv("SERVER_HOSTNAME"));}}
    EOS
    system ENV.cc, "testfile.c", "-L#{lib}", "-lfcgi", "-o", "testfile"
    assert_match "Request number 1 running on host", shell_output("./testfile")
  end
end

__END__
--- a/libfcgi/fcgi_stdio.c
+++ b/libfcgi/fcgi_stdio.c
@@ -40,7 +40,12 @@

 #ifndef _WIN32

+#if defined(__APPLE__)
+#include <crt_externs.h>
+#define environ (*_NSGetEnviron())
+#else
 extern char **environ;
+#endif

 #ifdef HAVE_FILENO_PROTO
 #include <stdio.h>
