# pinentry: Build a bottle for Linuxbrew
class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://gnupg.org/ftp/gcrypt/pinentry/pinentry-0.9.7.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.7.tar.bz2"
  sha256 "6398208394972bbf897c3325780195584682a0d0c164ca5a0da35b93b1e4e7b2"

  bottle do
    cellar :any
    revision 1
    sha256 "ed78e2eccacb6be15fbfaaf838bf15e473e7b48e3d7b966e6beae75f37bc12d8" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "libsecret" unless OS.mac?
  depends_on "gtk+" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-pinentry-qt
      --disable-pinentry-qt5
      --disable-pinentry-gnome3
    ]

    args << "--disable-pinentry-gtk2" if build.without? "gtk+"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
  end
end
