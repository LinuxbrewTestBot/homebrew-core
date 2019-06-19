# gettext: Build a bottle for Linuxbrew
class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.20.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.20.1.tar.xz"
  sha256 "53f02fbbec9e798b0faaf7c73272f83608e835c6288dd58be6c9bb54624a3800"

  bottle do
    sha256 "c1a033eb5b4c9221f8a00fea8d37ed13419966a4268037b20f7c81d94fef32f2" => :x86_64_linux
  end

  keg_only :shadowed_by_macos,
    "macOS provides the BSD gettext library & some software gets confused if both are in the library path"

  unless OS.mac?
    depends_on "ncurses"
    depends_on "zlib" # for libxml2
    # libxml2 is vendored here to break a cyclic dependency:
    # python -> tcl-tk -> xorg -> libxpm -> gettext -> libxml2 -> python
    resource("libxml2") do
      url "http://xmlsoft.org/sources/libxml2-2.9.7.tar.gz"
      mirror "ftp://xmlsoft.org/libxml2/libxml2-2.9.7.tar.gz"
      sha256 "f63c5e7d30362ed28b38bfa1ac6313f9a80230720b7fb6c80575eeab3ff5900c"
    end
  end

  def install
    resource("libxml2").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}",
                            "--without-python",
                            "--without-lzma"
      system "make", "install"
    end unless OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          ("--with-included-gettext" if OS.mac?),
                          "--with-included-glib",
                          "--with-included-libcroco",
                          "--with-included-libunistring",
                          "--with-emacs",
                          "--with-lispdir=#{elisp}",
                          "--disable-java",
                          "--disable-csharp",
                          # Don't use VCS systems to create these archives
                          "--without-git",
                          "--without-cvs",
                          "--without-xz",
                          ("--with-libxml2-prefix=#{libexec}" unless OS.mac?),
                          ("--with-libxml2-prefix=#{Formula["libxml2"].opt_prefix}" if OS.mac?)
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end

  test do
    system bin/"gettext", "test"
  end
end
