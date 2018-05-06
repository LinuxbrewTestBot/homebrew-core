# annie: Build a bottle for Linuxbrew
class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.6.10.tar.gz"
  sha256 "0653ea96a092621d3cf884269a0fc75fc767385e50acf9825fda1c4230b4b01b"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bf97f939899f984f9916aff6753479d49babd8d4221dd12de9cab6890b3a03f" => :x86_64_linux
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
