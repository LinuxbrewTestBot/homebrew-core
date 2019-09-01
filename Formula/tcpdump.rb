# tcpdump: Build a bottle for Linuxbrew
class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.9.2.tar.gz"
  sha256 "798b3536a29832ce0cbb07fafb1ce5097c95e308a6f592d14052e1ef1505fe79"
  revision 2
  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    sha256 "3c598caf02f9ca31d2892d9586a35c70400ca2a7895758b72e4672e83b646457" => :mojave
    sha256 "2fc5873438a618ba6140b37ba4e41f7f318b95e0608f17620104146843d99fbf" => :high_sierra
    sha256 "7b57d5f603ed82fb98c58198660596c7418af6b567c964d6873d23eb6629140b" => :sierra
    sha256 "8a69c859d38c9eff5858d0f7ea44b3771f90980e87229aaceb6311d1f97f2c1f" => :x86_64_linux
  end

  depends_on "libpcap"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--disable-smb",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    system sbin/"tcpdump", "--help"
  end
end
