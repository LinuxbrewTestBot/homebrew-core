# vegeta: Build a bottle for Linuxbrew
class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag => "v7.0.3",
      :revision => "f5e8a53b900b1509b8719aa94c30d4cf087a77e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0f8ad7d542b5ba0dbe2c6ef8554e3ab0020f688d273ee2fc4a1af6caa8dbb71" => :x86_64_linux
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tsenart/vegeta").install buildpath.children
    cd "src/github.com/tsenart/vegeta" do
      system "make", "vegeta"
      bin.install "vegeta"
      prefix.install_metafiles
    end
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match /Success +\[ratio\] +100.00%/, report
  end
end
