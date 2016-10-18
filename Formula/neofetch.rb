# neofetch: Build a bottle for Linuxbrew
class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.8.1.tar.gz"
  sha256 "dfa1e97f3a91af00da45af1bf3f6a197f545063dba129bd4db839b0139e68e24"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c5cbcf6dee70c3d9a537cf2ff73cd4d7adffc2267c555c835b448358f9cc76e" => :sierra
    sha256 "1c5cbcf6dee70c3d9a537cf2ff73cd4d7adffc2267c555c835b448358f9cc76e" => :el_capitan
    sha256 "1c5cbcf6dee70c3d9a537cf2ff73cd4d7adffc2267c555c835b448358f9cc76e" => :yosemite
    sha256 "bb7a234cc1ac2c0068eebebc1070a5aa7e2c22c47770ee9cdc9f1e434fba2c85" => :x86_64_linux
  end

  depends_on "screenresolution" => :recommended if OS.mac?
  depends_on "imagemagick" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--test", "--config off"
  end
end
