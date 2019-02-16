# libxslt: Build a bottle for Linuxbrew
class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.33.tar.gz"
  sha256 "8e36605144409df979cab43d835002f63988f3dc94d5d3537c12796db90e38c8"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    sha256 "59eba7a62043c9bc17d94777997b1080724b7118f33fa30a413f735e15de25bd" => :x86_64_linux
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libxslt.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "libxml2"
  depends_on "python@2" unless OS.mac?

  def install
    system "autoreconf", "-fiv" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          ("--without-crypto" unless OS.mac?),
                          "--without-python",
                          "--with-libxml-prefix=#{Formula["libxml2"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    To allow the nokogiri gem to link against this libxslt run:
      gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
  end
end
