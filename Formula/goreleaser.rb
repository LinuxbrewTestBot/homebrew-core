# goreleaser: Build a bottle for Linuxbrew
class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.94.0.tar.gz"
  sha256 "1f2490e42d541bd64939d5f81bc94fe5890b4715326ea8db6c1d56e26f4b04e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "515e0ee288f809a394920197ccd2a9738528b9a6c57712ee8df941a2842c6f0e" => :mojave
    sha256 "b2351f478cd4126d9f21768f0a00fb67d776f0d34c6e11fc865f707006b7368b" => :high_sierra
    sha256 "ad295314dc237428ac87bcaff37ff9ce039292403e32e4a9cf4beb38c9397ffc" => :sierra
    sha256 "610fb294a23fe7f8cb6f05a4717654fd84b10cea52bb18061b73cb057aa19034" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
                   "-o", bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
