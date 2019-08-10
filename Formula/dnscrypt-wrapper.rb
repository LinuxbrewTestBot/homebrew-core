# dnscrypt-wrapper: Build a bottle for Linuxbrew
class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/cofyc/dnscrypt-wrapper/archive/v0.4.2.tar.gz"
  sha256 "911856dc4e211f906ca798fcf84f5b62be7fdbf73c53e5715ce18d553814ac86"
  revision 1
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "129be9e2c08af0351401437f09a950f0d4050e99cce47da220561a3153d5334d" => :mojave
    sha256 "226bbce3fbcc39a1619bfd77451c6e0cf0d0054b61696acc2617e4f30580e69b" => :high_sierra
    sha256 "92da097e90b1cd593efb8d0d1a16c24dd016aa93933a3036be671b5596c6af0d" => :sierra
    sha256 "11c144deef3cb7e5c58f6447c4555f6680e005a8c8901f0b69e8a087f24c66de" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "libevent"
  depends_on "libsodium"

  def install
    system "make", "configure"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/dnscrypt-wrapper", "--gen-provider-keypair",
           "--provider-name=2.dnscrypt-cert.example.com",
           "--ext-address=192.168.1.1"
    system "#{sbin}/dnscrypt-wrapper", "--gen-crypt-keypair"
  end
end
