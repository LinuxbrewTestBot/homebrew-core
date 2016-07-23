# git-fixup: Build a bottle for Linuxbrew
class GitFixup < Formula
  desc "Alias for git commit --fixup <ref>"
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.1.0.tar.gz"
  sha256 "6e166709a18a0417776592493b82dc87f38766295825cfa68ce41adbf608c78e"

  head "https://github.com/keis/git-fixup.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "14abc437984183b8601be2fd2cc2d5e20cfc3155b9e10aa36fb7d07709ed1f8c" => :x86_64_linux
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    zsh_completion.install "completion.zsh" => "_git-fixup"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "fixup"
  end
end
