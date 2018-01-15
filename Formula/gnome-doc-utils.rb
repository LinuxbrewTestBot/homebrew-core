class GnomeDocUtils < Formula
  desc "Documentation utilities for the GNOME project"
  homepage "https://wiki.gnome.org/Projects/GnomeDocUtils"
  url "https://download.gnome.org/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz"
  sha256 "cb0639ffa9550b6ddf3b62f3b1add92fb92ab4690d351f2353cffe668be8c4a6"
  revision OS.mac? ? 1 : 2

  bottle do
    cellar :any_skip_relocation
    sha256 "7f90a3db07a45313f84139a416127d24dc37e2e044841d70f643ec53924eecb3" => :high_sierra
    sha256 "7f90a3db07a45313f84139a416127d24dc37e2e044841d70f643ec53924eecb3" => :sierra
    sha256 "7f90a3db07a45313f84139a416127d24dc37e2e044841d70f643ec53924eecb3" => :el_capitan
    sha256 "e77f8c9e8f74f99ee4a3a90e55c8752a8d7150de1959b4996c09b445682a91ad" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "docbook"
  depends_on "gettext"
  depends_on "libxml2"
  depends_on "libxslt" unless OS.mac?

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5" unless OS.mac?

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

  test do
    assert_match version.to_s, shell_output("#{bin}/gnome-doc-tool --version")
  end
end
