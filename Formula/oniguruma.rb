# oniguruma: Build a bottle for Linux
class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.4/onig-6.9.4.tar.gz"
  sha256 "4669d22ff7e0992a7e93e116161cac9c0949cd8960d1c562982026726f0e6d53"
  head "https://github.com/kkos/oniguruma.git"

  bottle do
    cellar :any
    sha256 "05e25bc53db0cf338a7f765da76c66260972d6b4e259be415bc17807a8b60fe9" => :catalina
    sha256 "ab2bb92e40e17569c54dda0ed3b3a0fc6f98be761107fba918754af75817de6f" => :mojave
    sha256 "1a97b801983a8929de40bcc829d50e3f37413dbb7076370e203deff76dad4357" => :high_sierra
    sha256 "c62e5991b68157abdbf3e969e6372e4fd01e3dbf6d9ed701d58b1f23ba9d2420" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onig-config --prefix"))
  end
end
