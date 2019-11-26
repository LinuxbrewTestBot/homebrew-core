# ethereum: Build a bottle for Linux
class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.9.8.tar.gz"
  sha256 "1907792553d6cfa68b28027bcbc2b14bf0f1a587509bfec4bd71d4051da738af"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e854e6bfc70d68e5ac67002fd05ddad597025d3babd04a81084950a2e6e4cb7c" => :mojave
    sha256 "44586e6b11ba6d17bedcb902172f9efcb238484cd6975096154b7571bb1c0145" => :high_sierra
    sha256 "522c9e98b92c6eee928dac08dcdb732130ac5f0a881abacc1674d4f1413400b8" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV.O0 unless OS.mac? # See https://github.com/golang/go/issues/26487
    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    EOS
    system "#{bin}/geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end
