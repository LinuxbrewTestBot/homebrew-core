class GnomeThemesStandard < Formula
  desc "Default themes for the GNOME desktop environment"
  homepage "https://gitlab.gnome.org/GNOME/gnome-themes-extra"
  url "https://download.gnome.org/sources/gnome-themes-standard/3.22/gnome-themes-standard-3.22.3.tar.xz"
  sha256 "61dc87c52261cfd5b94d65e8ffd923ddeb5d3944562f84942eeeb197ab8ab56a"
  revision 2

  bottle do
    cellar :any
    sha256 "6fb1066c6af0428fee29272851b4d7fbf10bac3bec4ed48ce6cffb780a3175f1" => :catalina
    sha256 "0275e08061a7fc1c641729075add70362499309548d9f82a65f30397fe756073" => :mojave
    sha256 "7c871fcd54d59a07719e5b1f22ca003921e479548ee9d13c5910af482b47891e" => :high_sierra
    sha256 "7e5bfe5894c0498b6b9325a782e4ea1c756b042d527815547cba6e6f411095a2" => :sierra
    sha256 "f942924775fa9036498f9efa56c69e6857d13a4e5a6546420d04f34710c9c0c0" => :x86_64_linux
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5" unless OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-gtk3-engine"

    system "make", "install"
  end

  test do
    assert_predicate share/"icons/HighContrast/scalable/actions/document-open-recent.svg", :exist?
    assert_predicate lib/"gtk-2.0/2.10.0/engines/libadwaita.so", :exist?
  end
end
