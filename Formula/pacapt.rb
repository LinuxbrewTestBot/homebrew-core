# pacapt: Build a bottle for Linuxbrew
class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.3.15.tar.gz"
  sha256 "766f10320082c542fba2a5db1e0dab46e51dc45be07ade53c99a1ce3b1591245"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d0c8e6cef4f3f16228884268399a113318ddf3fb4ebfe9568145e6c13b55c20" => :x86_64_linux
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
