# annie: Build a bottle for Linuxbrew
class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.0.tar.gz"
  sha256 "dab16f51b7722e41cabef333f206a0e46d1a14eeda39b6be0f606c63ae69f930"

  bottle do
    cellar :any_skip_relocation
    sha256 "95dd906d9b8bb08a8b418cc8f9ffbcf90a84c90d3b064eb26b674e5d84cb24da" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/iawia002/annie").install buildpath.children
    cd "src/github.com/iawia002/annie" do
      system "go", "build", "-o", bin/"annie"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
