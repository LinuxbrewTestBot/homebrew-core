# freetype: Build a bottle for Linuxbrew
class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  # Note: when bumping freetype's version, you must also bump revisions of
  # formula with "full path" references to freetype in their pkgconfig.
  # See https://github.com/Homebrew/legacy-homebrew/pull/44587
  url "https://downloads.sf.net/project/freetype/freetype2/2.6.5/freetype-2.6.5.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.6.5.tar.bz2"
  sha256 "e20a6e1400798fd5e3d831dd821b61c35b1f9a6465d6b18a53a9df4cf441acf0"

  bottle do
    cellar :any
    sha256 "2d5cc9261d3861eb6441c059bc3fa8f78835c8b72e5f7526b1d75f3556f3289c" => :x86_64_linux
  end

  keg_only :provided_pre_mountain_lion

  option :universal
  option "without-subpixel", "Disable sub-pixel rendering (a.k.a. LCD rendering, or ClearType)"

  depends_on "libpng"

  def install
    if build.with? "subpixel"
      inreplace "include/freetype/config/ftoption.h",
          "/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */",
          "#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING"
    end

    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--without-harfbuzz"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/freetype-config", "--cflags", "--libs", "--ftversion",
      "--exec-prefix", "--prefix"
  end
end
