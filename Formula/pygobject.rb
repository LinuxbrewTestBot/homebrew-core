# pygobject: Build a bottle for Linuxbrew
class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.6.tar.bz2"
  sha256 "e4bfe017fa845940184c82a4d8949db3414cb29dfc84815fb763697dc85bdcee"
  revision 1

  bottle do
    cellar :any
    sha256 "962e657ab8f6f3073a8c38f2cd826bde1ab45895d508c653fd6fe1bc81d09517" => :x86_64_linux
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :python

  # https://bugzilla.gnome.org/show_bug.cgi?id=668522
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/pygobject/patch-enum-types.diff"
    sha256 "99a39c730f9af499db88684e2898a588fdae9cd20eef70675a28c2ddb004cb19"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make", "install"
    (lib/"python2.7/site-packages/pygtk.pth").append_lines <<-EOS.undent
      #{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0
    EOS
  end

  test do
    system "python", "-c", "import dsextras"
  end
end
