# convox: Build a bottle for Linuxbrew
class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180503151229.tar.gz"
  sha256 "29a9571b3ae845d0f23a0ce28bafc96dbd8d6ee20110cf8e46208bb4e9a47db5"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b011be105f9676b58fcba4da331d119b3f37acd5ef72dd40f62343fff64a34a" => :x86_64_linux
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
