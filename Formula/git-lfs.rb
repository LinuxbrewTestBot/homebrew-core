# git-lfs: Build a bottle for Linuxbrew
class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.3.1.tar.gz"
  sha256 "eab3ae0a423106c3256228550eccbca871f9adc9c1b8f8075dbe5c48e0ca804f"

  bottle do
    cellar :any_skip_relocation
    sha256 "61dbb6cc41d072f943b49f6dcf7777d395965d1516c65d9f71a84802c01ee605" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
