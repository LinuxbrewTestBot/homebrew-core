# libgpg-error: Build a bottle for Linuxbrew
class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.23.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.23.tar.bz2"
  sha256 "7f0c7f65b98c4048f649bfeebfa4d4c1559707492962504592b985634c939eaa"

  bottle do
    cellar :any
    sha256 "34657f13f5dc07c4ed2610351ec68acf4f65bb10f321d464bcfdea4819489079" => :x86_64_linux
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
