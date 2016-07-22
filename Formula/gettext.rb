# gettext: Build a bottle for Linuxbrew
class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftpmirror.gnu.org/gettext/gettext-0.19.8.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.19.8.1.tar.xz"
  sha256 "105556dbc5c3fbbc2aa0edb46d22d055748b6f5c7cd7a8d99f8e7eb84e938be4"

  bottle do
    sha256 "dae894eedee985c8c15b9f1525686130c1c9dcdcfca71632cfbf37dd01747c21" => :x86_64_linux
  end

  keg_only :shadowed_by_osx, "OS X provides the BSD gettext library and some software gets confused if both are in the library path."

  option :universal

  # https://savannah.gnu.org/bugs/index.php?46844
  depends_on "libxml2" if MacOS.version <= :mountain_lion
  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    ENV.libxml2
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          ("--with-included-gettext" if OS.mac?),
                          "--with-included-glib",
                          "--with-included-libcroco",
                          "--with-included-libunistring",
                          "--with-emacs",
                          "--with-lispdir=#{share}/emacs/site-lisp/gettext",
                          "--disable-java",
                          "--disable-csharp",
                          # Don't use VCS systems to create these archives
                          "--without-git",
                          "--without-cvs",
                          "--without-xz"
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end

  test do
    system "#{bin}/gettext", "test"
  end
end
