# git-lfs: Build a bottle for Linuxbrew
class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.2.1.tar.gz"
  sha256 "a55daef5a95d75f64d44737076b7f7fd4873ab59f08feb55b412960e98da73ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "184328b95249cca939017c2de794240436961a84dc4dcb5155b7499036b089dd" => :x86_64_linux
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
