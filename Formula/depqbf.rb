class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-4.01.tar.gz"
  sha256 "0246022128890d24b926a9bd17a9d4aa89b179dc05a0fedee33fa282c0ceba5b"
  head "https://github.com/lonsing/depqbf.git"

  bottle do
    cellar :any
    revision 1
    sha256 "a4c2e672a54b8a52abadf59aadc4df40f4207f554d1e1cf233aeb47f86f9151a" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "depqbf"
    lib.install "libqdpll.#{OS.mac? ? "1.0.dylib" : "so.1.0"}"
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end
