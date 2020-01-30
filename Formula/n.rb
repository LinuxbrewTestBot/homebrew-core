# n: Build a bottle for Linux
class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.2.0.tar.gz"
  sha256 "b200b684fd5a7cb352b74108ec53a1d57497b1a97c73479d2ebf8b3474766aea"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e9ea122f44880fe1c00b62b1fd4237efb9e089234c09bb3707b549ac6cc3d4b" => :catalina
    sha256 "3e9ea122f44880fe1c00b62b1fd4237efb9e089234c09bb3707b549ac6cc3d4b" => :mojave
    sha256 "3e9ea122f44880fe1c00b62b1fd4237efb9e089234c09bb3707b549ac6cc3d4b" => :high_sierra
    sha256 "b4e58889ee5dc2b59acf415c0f2a2d105ecc1e9bc59db97d555bb7e3936f093f" => :x86_64_linux
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
