class Avahi < Formula
  desc "Service Discovery for Linux using mDNS/DNS-SD"
  homepage "https://avahi.org"
  url "https://github.com/lathiat/avahi/archive/v0.7.tar.gz"
  sha256 "fd45480cef0559b3eab965ea3ad4fe2d7a8f27db32c851a032ee0b487c378329"
  # tag "linux"

  bottle do
    sha256 "7ebd37d29fd23ade0e81a3541b39748e3fb1f90457e34865d0a789115f4ba34a" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "pkg-config" => :build
  depends_on "xmltoman" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libdaemon"

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5"

    system "./bootstrap.sh", "--disable-debug",
                             "--disable-dependency-tracking",
                             "--disable-silent-rules",
                             "--prefix=#{prefix}",
                             "--sysconfdir=#{prefix}/etc",
                             "--localstatedir=#{prefix}/var",
                             "--disable-mono",
                             "--disable-monodoc",
                             "--disable-python",
                             "--disable-qt3",
                             "--disable-qt4",
                             "--disable-gtk",
                             "--disable-gtk3",
                             "--with-distro=none",
                             "--with-systemdsystemunitdir=no"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS
      #include <string.h>

      #include <ggz.h>

      int main(void)
      {
        int errs = 0;
        char *teststr, *instr, *outstr;

        teststr = "&quot; >< &&amp";
        instr = teststr;
        outstr = ggz_xml_escape(instr);
        instr = ggz_xml_unescape(outstr);
        if(strcmp(instr, teststr)) {
          errs++;
        }
        ggz_free(instr);
        ggz_free(outstr);
        ggz_memory_check();

        return errs;
      }
    EOS
    system ENV.cc, "test.c", ENV.cppflags, "-L/usr/lib", "-L#{lib}", "-lggz", "-o", "test"
    system "./test"
  end
end
