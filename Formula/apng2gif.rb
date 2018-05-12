class Apng2gif < Formula
  desc "Convert APNG animations into animated GIF format"
  homepage "https://apng2gif.sourceforge.io/"
  url "https://downloads.sourceforge.net/apng2gif/apng2gif-1.8-src.zip"
  sha256 "9a07e386017dc696573cd7bc7b46b2575c06da0bc68c3c4f1c24a4b39cdedd4d"
  revision 2 unless OS.mac?

  bottle do
    cellar :any
    rebuild 1
    sha256 "107c6e920ae40732bf88fe47eb18b22fda83fc86d4a23415e2c3c4bbc493d19e" => :x86_64_linux
  end

  depends_on "libpng"

  if MacOS.version <= :yosemite
    depends_on "gcc"
    fails_with :clang
  end

  def install
    system "make"
    bin.install "apng2gif"
  end

  test do
    cp test_fixtures("test.png"), testpath/"test.png"
    system bin/"apng2gif", testpath/"test.png"
    assert_predicate testpath/"test.gif", :exist?, "Failed to create test.gif"
  end
end
