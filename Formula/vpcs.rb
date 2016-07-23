class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "http://vpcs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/vpcs/0.6/vpcs-0.6-src.tbz"
  sha256 "cc311b0dea9ea02ef95f26704d73e34d293caa503600a0acca202d577afd3ceb"

  bottle do
    cellar :any_skip_relocation
    sha256 "6efe35440add61e88bceedca795380160c267740f9ea056d015147698020ed7d" => :x86_64_linux
  end

  def install
    cd "src" do
      system "make", "-f", "Makefile.#{OS.mac? ? "osx" : "linux"}"
      bin.install "vpcs"
    end
  end

  test do
    system "vpcs", "--version"
  end
end
