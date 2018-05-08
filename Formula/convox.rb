# convox: Build a bottle for Linuxbrew
class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180507173314.tar.gz"
  sha256 "404d502250da12c4b4ef5280aeecd2f6908cb790f4f8b1743a98dfd13c3ccbdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "49d2b29193ab45303a5217d5decd06b1cec6517970df413619a7eb4b3895fe31" => :high_sierra
    sha256 "c99c02f757eed4bc7cdb1826cc4dece242e33344541fa13b04222fdd942ac69c" => :sierra
    sha256 "15bea3c86ffa077cf8c0ec7fd8bba6df0148336d6be7971b5516e5d1c3f068a6" => :el_capitan
    sha256 "176a24cf099f05c1cf1d65294a5b0c2be9ad7dfd42e090a8813f590731a48da0" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
