# goreleaser: Build a bottle for Linux
class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.120.7",
      :revision => "25f9742878f47d5184a806fcaafc46ce82b7f705"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c0a1f43c4dec19fb24f6e2d1dc5dc4af141e72f9d3e7bbf4dc03232059f5102" => :catalina
    sha256 "5ceaf72a988bc292f94541e7fd759294b6a0f64a1774edfae36f3f17ebcbcfb8" => :mojave
    sha256 "1147e1d42e8e09e06dd4d3b648fa5762470730c794efea6c8560432bead3f3a4" => :high_sierra
    sha256 "a84ab50a8216e35036c8fbc387561fb4a4fb21aa5f774e1f42f5d75580a39d29" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/goreleaser/goreleaser"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "go", "build", "-ldflags",
                   "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
                   "-o", bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
