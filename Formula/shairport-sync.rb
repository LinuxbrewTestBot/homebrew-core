# shairport-sync: Build a bottle for Linuxbrew
class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.3.2.tar.gz"
  sha256 "a8f580fa8eb71172f6237c0cdbf23287b27f41f5399f5addf8cd0115a47a4b2b"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    cellar :any_skip_relocation
    sha256 "a866ca2d84b4c21ab43bcef5a5fa96b56d92ff15530d4263bb05eef74ccb7202" => :mojave
    sha256 "ff2f3c05b3c94b0ae0d2f7a7cbabbfaa8171e7fd4f97cb0e7dd9c90aedc97a3d" => :high_sierra
    sha256 "10638bbb76575d535e8cce1aa1b57801baa576acf2e79d687c9aa244baac1b85" => :sierra
    sha256 "b47b716e9e6b13116a9ce2a680b4360a8fbaefc1a700dbed54a2ec05555796fc" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@1.1"
  depends_on "popt"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-os=darwin
      --with-ssl=openssl
      --with-ao
      --with-stdout
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
      --prefix=#{prefix}
    ]
    args << "--with-dns_sd" if OS.mac? # Disable bonjour in Linux
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V")
    assert_match "OpenSSL-dns_sd-ao-stdout-pipe-soxr-metadata", output
  end
end
