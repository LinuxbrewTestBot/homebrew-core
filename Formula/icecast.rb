# icecast: Build a bottle for Linuxbrew
class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/icecast/icecast-2.4.3.tar.gz"
  sha256 "c85ca48c765d61007573ee1406a797ae6cb31fb5961a42e7f1c87adb45ddc592"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f5d7003e198e5106a08c7ecdad8124c1bfba72a82e7d6ef7ffa479ca59aacc1b" => :mojave
    sha256 "29b910add5cd848b1cbfb91ef13632d7b6a0df8dc42fc8425b6a73062168efbc" => :high_sierra
    sha256 "c30f3e18ff8e95db6517b48114412ef5aed180cf0a5298b0962efd1ffdb08cdb" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "openssl"
  depends_on "curl" unless OS.mac?
  depends_on "libxslt" unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    (prefix+"var/log/icecast").mkpath
    touch prefix+"var/log/icecast/error.log"
  end
end
