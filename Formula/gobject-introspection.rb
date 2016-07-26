# gobject-introspection: Build a bottle for Linuxbrew
class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.48/gobject-introspection-1.48.0.tar.xz"
  sha256 "fa275aaccdbfc91ec0bc9a6fd0562051acdba731e7d584b64a277fec60e75877"

  bottle do
    sha256 "bb710635ebe1036f8ad3c321bb9b53e69587833b300978b7a7c9b4463f4b41fe" => :x86_64_linux
  end

  option :universal

  depends_on "pkg-config" => :run
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  # System python in Mavericks or below has bug in distutils/sysconfig.py, which breaks the install.
  #    Caught exception: <type 'exceptions.AttributeError'> AttributeError("'NoneType' object has no attribute 'get'",)
  #    > /System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/distutils/sysconfig.py(171)customize_compiler()
  depends_on "python" if MacOS.version <= :mavericks
  depends_on "bison" unless OS.mac?
  depends_on "flex" unless OS.mac?

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    ENV.universal_binary if build.universal?
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "configure" do |s|
      s.change_make_var! "GOBJECT_INTROSPECTION_LIBDIR", "#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "PYTHON=python"
    system "make"
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert (testpath/"Tut-0.1.typelib").exist?
  end
end
