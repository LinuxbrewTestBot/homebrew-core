class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.4.tar.bz2"
  sha256 "668293fcc4b3c59765cdee5cee05941091c0879edcc24dfec5455ef83912e45c"
  revision 1 unless OS.mac?

  # The bottle tooling is too lenient and thinks fontconfig
  # is relocatable, but it has hardcoded paths in the executables.
  bottle do
    sha256 "05f90844fa324f510fdda497177a12ae30532368ecd7f4ead5ecd63fcd0eb66b" => :sierra
    sha256 "2cea2573e122283e3dddac508b5eba66e70e5bdb3def7628a2c68c40a0abbd7d" => :el_capitan
    sha256 "ef4e224f92de39b5694fde64dd1087dc28684f43611ad4a8d729f3891ed2187d" => :yosemite
    sha256 "02d5c04e934bcfeddbdf13f48ca4446b7b8bb98d85bb9bb2d7ad39561d78ad74" => :x86_64_linux
  end

  pour_bottle? do
    default_prefix = BottleSpecification::DEFAULT_PREFIX
    reason "The bottle needs to be installed into #{default_prefix}."
    # c.f. the identical hack in lua
    # https://github.com/Homebrew/homebrew/issues/47173
    satisfy { HOMEBREW_PREFIX.to_s == default_prefix }
  end

  head do
    url "https://anongit.freedesktop.org/git/fontconfig", :using => :git

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_pre_mountain_lion

  option "without-docs", "Skip building the fontconfig docs"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  unless OS.mac?
    depends_on "bzip2"
    depends_on "expat"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gperf" => :build
    depends_on "libtool" => :build
  end

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    if MacOS.version == :sierra
      font_dirs << "/System/Library/Assets/com_apple_MobileAsset_Font3"
    elsif MacOS.version == :high_sierra
      font_dirs << "/System/Library/Assets/com_apple_MobileAsset_Font4"
    end

    system "autoreconf", "-iv" if build.head? || !OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--with-add-fonts=#{font_dirs.join(",")}",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          ("--disable-docs" if build.without? "docs")
    system "make", "install", "RUN_FC_CACHE_TEST=false"
  end

  def post_install
    ohai "Regenerating font cache, this may take a while"
    system "#{bin}/fc-cache", "-frv"
  end

  test do
    system "#{bin}/fc-list"
  end
end
