# aha: Build a bottle for Linuxbrew
class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.9.tar.gz"
  sha256 "9aefb7d7838e2061672813482d062ac4c32c932f7f8f0928766ba0152fec3d77"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7fddc4ed6a1a278485bebc5eef0e28f6900896d002d0470f27001017b548f88" => :x86_64_linux
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
