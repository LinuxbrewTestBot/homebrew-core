# libassuan: Build a bottle for Linuxbrew
class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.4.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.3.tar.bz2"
  sha256 "22843a3bdb256f59be49842abf24da76700354293a066d82ade8134bb5aa2b71"
  revision 1

  bottle do
    cellar :any
    sha256 "99bff9cd81663fa4c98bb8f8a4313a85d750c12155681b46d132007edd244bff" => :x86_64_linux
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libassuan-config", prefix, opt_prefix
  end

  test do
    system bin/"libassuan-config", "--version"
  end
end
