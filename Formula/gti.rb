# gti: Build a bottle for Linuxbrew
class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "http://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.3.0.tar.gz"
  sha256 "f344b9af622980e3689d3bc7866a913c6794ff5c22b09fa92e2b684309aba958"

  head "https://github.com/rwos/gti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbd3568e097a7df95cba9cfab2ea7cd2e1c10d846004bb6dfc4c9ecd97dec1b6" => :x86_64_linux
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
