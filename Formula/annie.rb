# annie: Build a bottle for Linuxbrew
class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.1.tar.gz"
  sha256 "135485d9cbf3711bfbea6b79090e898bef82ef329c922ed222e96c326b15af52"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d5cb12ffe1de1d5b1f2c96fc4b68de844993add4730a7ff41562e0ed82a24c6" => :x86_64_linux
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
