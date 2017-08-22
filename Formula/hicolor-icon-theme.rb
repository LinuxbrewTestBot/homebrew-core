class HicolorIconTheme < Formula
  desc "Fallback theme for FreeDesktop.org icon themes"
  homepage "https://wiki.freedesktop.org/www/Software/icon-theme/"
  url "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.16.tar.xz"
  sha256 "b0f8e770815fc80f7719d367608a2eb05572570cfca2734f986deae73e7d1f39"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff44315be3f8d3e81e8d1cc287affa37a58fe0a73924ad13b57103a5eae71dc9" => :x86_64_linux
  end

  head do
    url "https://anongit.freedesktop.org/git/xdg/default-icon-theme.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
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
