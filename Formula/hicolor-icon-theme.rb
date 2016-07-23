# hicolor-icon-theme: Build a bottle for Linuxbrew
class HicolorIconTheme < Formula
  desc "Fallback theme for FreeDesktop.org icon themes"
  homepage "https://wiki.freedesktop.org/www/Software/icon-theme/"
  url "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.15.tar.xz"
  sha256 "9cc45ac3318c31212ea2d8cb99e64020732393ee7630fa6c1810af5f987033cc"

  head do
    url "https://anongit.freedesktop.org/git/xdg/default-icon-theme.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1956805394228cb2941615de3bb71994bf8fc6c1763ff799dfda751656eb5b04" => :x86_64_linux
  end

  def install
    args = %W[--prefix=#{prefix} --disable-silent-rules]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    File.exist? share/"icons/hicolor/index.theme"
  end
end
