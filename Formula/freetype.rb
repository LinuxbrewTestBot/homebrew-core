# freetype: Build a bottle for Linuxbrew
class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.10.1/freetype-2.10.1.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.10.1.tar.xz"
  sha256 "16dbfa488a21fe827dc27eaf708f42f7aa3bb997d745d31a19781628c36ba26f"

  bottle do
    cellar :any
    sha256 "13df71e01ffd8a84268cbd441f35f00664e751a0f03167cd3d243cc8f03c2cb6" => :x86_64_linux
  end

  depends_on "libpng"
  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
