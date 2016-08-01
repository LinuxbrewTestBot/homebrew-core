# dirmngr: Build a bottle for Linuxbrew
class Dirmngr < Formula
  desc "Server for managing certificate revocation lists"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/dirmngr/dirmngr-1.1.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/dirmngr/dirmngr-1.1.1.tar.bz2"
  sha256 "d2280b8c314db80cdaf101211a47826734443436f5c3545cc1b614c50eaae6ff"
  revision 2

  bottle do
    sha256 "e3eb4f508ea39d2098e872d8d7dfeacd53aca498918f229a9d5d1a57c726553d" => :x86_64_linux
  end

  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "pth"
  depends_on "homebrew/dupes/openldap" unless OS.mac?

  patch :p0 do
    # patch by upstream developer to fix an API incompatibility with libgcrypt >=1.6.0
    # causing immediate segfault in dirmngr. see https://bugs.gnupg.org/gnupg/issue1590
    url "https://bugs.gnupg.org/gnupg/file419/dirmngr-pth-fix.patch"
    sha256 "0efbcf1e44177b3546fe318761c3386a11310a01c58a170ef60df366e5160beb"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make"
    system "make", "install"
  end

  test do
    system "dirmngr-client", "--help"
    system "dirmngr", "--help"
  end
end
