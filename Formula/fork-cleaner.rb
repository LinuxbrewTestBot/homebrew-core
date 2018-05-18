# fork-cleaner: Build a bottle for Linuxbrew
class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.4.0.tar.gz"
  sha256 "74cbaeef71ceb12fb90e49c325d9da661eef1b5e395c8eeec04e5643b04877e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "f175cdad99f541cdb93e52806fe6d59e2880cd37aa659c346513f2cb74790dba" => :x86_64_linux
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/caarlos0/fork-cleaner"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure"
      system "make"
      bin.install "fork-cleaner"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
