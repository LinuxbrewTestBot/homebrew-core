class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.4.0",
      :revision => "d5bb3a33e19215169082390cf29144f7b1869f8e"
  head "https://github.com/code-ready/crc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1cbd0162d99bad01ddb68ec74c4672635da35be0637a01c9334facbd2bc80f3" => :catalina
    sha256 "42a0f12a5aae455cd5c6d8dadbddc930dc54b8ea14693f7a7c9a2952978cf717" => :mojave
    sha256 "7f5fef96248a517547beeb9d6ebe1477745f0865165c0ab7cd10a7c6aef4f00a" => :high_sierra
    sha256 "4d3b32dad6bd6451aafaffcd9f7a36c29e01c0875dfb0f22c33a95fbcbb30451" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    os = OS.mac? ? "macos" : "linux"
    system "make", "out/#{os}-amd64/crc"
    bin.install "out/#{os}-amd64/crc"
  end

  test do
    assert_match /^crc version: #{version}/, shell_output("#{bin}/crc version")

    # Should error out as running crc requires root
    status_output = shell_output("#{bin}/crc setup 2>&1", 1)
    if !OS.mac? && ENV["CI"]
      assert_match "You need to enable virtualization in BIOS", status_output
    else
      assert_match "Unable to set ownership", status_output
    end
  end
end
