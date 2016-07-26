# n: Build a bottle for Linuxbrew
class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  head "https://github.com/tj/n.git"
  url "https://github.com/tj/n/archive/v2.1.0.tar.gz"
  sha256 "6fb70b39065a6d6ba1d12915906c06907a3e1afbb25c7653ad23a21217f51c76"

  bottle do
    cellar :any_skip_relocation
    sha256 "058cb1a66bd064bf8a687a51fa17b43c6554b59514b853be8ac9f813be022a81" => :x86_64_linux
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
