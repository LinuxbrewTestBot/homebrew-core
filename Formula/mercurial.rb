# mercurial: Build a bottle for Linuxbrew
# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.9.tar.gz"
  sha256 "834f25dcff44994198fb8a7ba161a6e24204dbd63c8e6270577e06e6cedbdabc"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b0a8e6d1ddcce909f66f78e4d8e3dbe7e70b430f3e5a14d780350f3e9c072cb" => :x86_64_linux
  end

  depends_on :python unless OS.mac?

  def install
    ENV.minimal_optimization if MacOS.version <= :snow_leopard

    system "make", "PREFIX=#{prefix}", "install-bin"
    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # install the completion scripts
    bash_completion.install "contrib/bash_completion" => "hg-completion.bash"
    zsh_completion.install "contrib/zsh_completion" => "_hg"
  end

  test do
    system "#{bin}/hg", "init"
  end
end
