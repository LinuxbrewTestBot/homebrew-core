# git-fixup: Build a bottle for Linuxbrew
class GitFixup < Formula
  desc "Alias for git commit --fixup <ref>"
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.1.2.tar.gz"
  sha256 "d34b5b45591bfd08e1091d7435b07b1a60af1e53463b94e9ce727a341ee6bdbb"

  head "https://github.com/keis/git-fixup.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c6e69dcc8a9dd6ad1bef0181b729cf310a8ff36c75f4671f0606272203dbf67" => :high_sierra
    sha256 "3c6e69dcc8a9dd6ad1bef0181b729cf310a8ff36c75f4671f0606272203dbf67" => :sierra
    sha256 "3c6e69dcc8a9dd6ad1bef0181b729cf310a8ff36c75f4671f0606272203dbf67" => :el_capitan
    sha256 "edf482126a8b1dc7858a68791a498b1ec87751bc8a1550693674dc608479a17b" => :x86_64_linux
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    zsh_completion.install "completion.zsh" => "_git-fixup"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
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
