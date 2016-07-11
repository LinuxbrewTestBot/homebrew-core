# gnome-doc-utils: Build a bottle for Linuxbrew
class GnomeDocUtils < Formula
  desc "Documentation utilities for the GNOME project"
  homepage "https://live.gnome.org/GnomeDocUtils"
  url "https://download.gnome.org/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz"
  sha256 "cb0639ffa9550b6ddf3b62f3b1add92fb92ab4690d351f2353cffe668be8c4a6"

  bottle do
    sha256 "4972d1c1c8637fa372cab22e50a1c3a95fd302b60b7e022f6b1e99eb083baa2f" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on :python
  depends_on "docbook"
  depends_on "gettext"
  depends_on "libxml2" => "with-python"
  depends_on "libxslt" unless OS.mac?

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-scrollkeeper",
                          "--enable-build-utils=yes"

    # Compilation doesn't work right if we jump straight to make install
    system "make"
    system "make", "install"
  end
end
