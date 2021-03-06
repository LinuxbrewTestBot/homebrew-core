class Libcap < Formula
  desc "User-space interfaces to POSIX 1003.1e capabilities"
  homepage "https://sites.google.com/site/fullycapable/"
  url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.27.tar.xz"
  sha256 "dac1792d0118bee6aae6ba7fb93ff1602c6a9bda812fd63916eee1435b9c486a"
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
    sha256 "ceb5ceec04cc07d29ac5c2d8a37db74a491d5177ef92c4e1c172b9eb2a6dc6e4" => :x86_64_linux
  end

  def install
    system "make", "install", "prefix=#{prefix}", "lib=lib", "RAISE_SETFCAP=no"
  end

  test do
    assert_match "usage", shell_output("#{sbin}/getcap 2>&1", 1)
  end
end
