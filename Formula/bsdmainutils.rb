class Bsdmainutils < Formula
  desc "Collection of utilities from FreeBSD"
  homepage "https://packages.debian.org/sid/bsdmainutils"
  url "http://ftp.debian.org/debian/pool/main/b/bsdmainutils/bsdmainutils_9.0.12.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/debian/pool/main/b/bsdmainutils/bsdmainutils_9.0.12.tar.gz"
  sha256 "9b6989932eabb43fa0137f4e5589e9b1ec70ea0249276a31dd311b3664bfc97f"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "b52153c929451ce34b8b0f3f28080b15477b74600527d5def404739f6f0779d6" => :x86_64_linux
  end

  depends_on "homebrew/dupes/ncurses" unless OS.mac?
  depends_on "libbsd" unless OS.mac?

  def install
    File.open("debian/patches/series").each do |patch|
      system "patch -p1 <debian/patches/#{patch}"
    end
    inreplace "Makefile", "/usr/", "#{prefix}/"
    inreplace "config.mk", "/usr/", "#{prefix}/"
    inreplace "config.mk", " -o root -g root", ""
    inreplace "usr.bin/write/Makefile", "chown root:tty $(bindir)/$(PROG)", ""
    system "make", "install"
  end

  test do
    system "#{bin}/cal"
  end
end
