# git-lfs: Build a bottle for Linuxbrew
class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.4.0.tar.gz"
  sha256 "0c357091d634a35ca539245eca488fc84a08c1524fbd2f96e4b085911001e8b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "b122688571b163ad6932130159d59fac412a6187c97148bdc15f63d129d17883" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  def caveats; <<-EOS.undent
    Update your git config to finish installation:

      # Update global git config
      $ git lfs install

      # Update system git config
      $ git lfs install --system
    EOS
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
