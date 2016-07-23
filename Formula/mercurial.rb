# mercurial: Build a bottle for Linuxbrew
# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.8.4.tar.gz"
  sha256 "4b2e3ef19d34fa1d781cb7425506a05d4b6b1172bab69d6ea78874175fdf3da6"

  bottle do
    cellar :any_skip_relocation
    sha256 "088c4e091d12c89cdb21dae3f327da31ae614d7b291406a52ef1e26bef91c9e4" => :x86_64_linux
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
