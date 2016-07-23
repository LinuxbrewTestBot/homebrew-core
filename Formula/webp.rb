# webp: Build a bottle for Linuxbrew
class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.5.1.tar.gz"
  # Because Google-hosted upstream URL gets firewalled in some countries.
  mirror "https://dl.bintray.com/homebrew/mirror/webp-0.5.1.tar.gz"
  sha256 "6ad66c6fcd60a023de20b6856b03da8c7d347269d76b1fd9c3287e8b5e8813df"

  bottle do
    cellar :any
    sha256 "0acfdc4901380b84c5f8bc75044e656c76c140c2bf3bb8f446d0abbec343b6e2" => :x86_64_linux
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => (OS.mac? ? :optional : :recommended)
  depends_on "giflib" => :optional

  def install
    system "./autogen.sh" if build.head?

    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gl",
                          "--enable-libwebpmux",
                          "--enable-libwebpdemux",
                          "--enable-libwebpdecoder",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert File.exist?("webp_test.webp")
  end
end
