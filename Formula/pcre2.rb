# pcre2: Build a bottle for Linuxbrew
class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "http://www.pcre.org/"

  head "svn://vcs.exim.org/pcre2/code/trunk"

  stable do
    url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.21.tar.bz2"
    mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre2/10.21/pcre2-10.21.tar.bz2"
    sha256 "c66a17509328a7251782691093e75ede7484a203ebc6bed3c08122b092ccd4e0"
    # Patch from http://vcs.pcre.org/pcre2/code/trunk/src/pcre2_compile.c?view=patch&r1=489&r2=488&pathrev=489
    # Fixes CVE-2016-3191
    # Can be dropped once 10.22 is released
    patch :p2, :DATA
  end

  bottle do
    cellar :any
    sha256 "74f83bfff45dec73ef08d65b297668c4ac9d498cf81cdbcbb8d72d01e9604ea3" => :x86_64_linux
  end

  option :universal

  depends_on "bzip2" unless OS.mac?

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pcre2grep", "regular expression", "#{prefix}/README"
  end
end
__END__
--- code/trunk/src/pcre2_compile.c	2016/02/06 16:40:59	488
+++ code/trunk/src/pcre2_compile.c	2016/02/10 18:24:02	489
@@ -5901,10 +5901,22 @@
               goto FAILED;
               }
             cb->had_accept = TRUE;
+
+            /* In the first pass, just accumulate the length required;
+            otherwise hitting (*ACCEPT) inside many nested parentheses can
+            cause workspace overflow. */
+
             for (oc = cb->open_caps; oc != NULL; oc = oc->next)
               {
-              *code++ = OP_CLOSE;
-              PUT2INC(code, 0, oc->number);
+              if (lengthptr != NULL)
+                {
+                *lengthptr += CU2BYTES(1) + IMM2_SIZE;
+                }
+              else
+                {
+                *code++ = OP_CLOSE;
+                PUT2INC(code, 0, oc->number);
+                }
               }
             setverb = *code++ =
               (cb->assert_depth > 0)? OP_ASSERT_ACCEPT : OP_ACCEPT;
