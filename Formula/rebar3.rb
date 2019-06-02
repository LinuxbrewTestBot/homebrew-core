# rebar3: Build a bottle for Linuxbrew
class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.11.0.tar.gz"
  sha256 "d0f567bf5cfd60e16650b151a7caa24bf8164fb1c31359ce8b0452a683209421"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7118470996e2db24ea674753a54a111d69c07dfba914b364fa2e060e440fe6a" => :mojave
    sha256 "d9190ecd5789c6ea39f4f803effd192ab0c5800eff7fc5a4f201c095d76a940e" => :high_sierra
    sha256 "a04351f9d088bf25f9ddd32746f20474c0fe25a77bb72cddf88af39eb2918e44" => :sierra
    sha256 "07eea26fd537865377f53797f10dc434881f0a787f4a2da1237b76f4e785bbf8" => :x86_64_linux
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "priv/shell-completion/bash/rebar3"
    zsh_completion.install "priv/shell-completion/zsh/_rebar3"
    fish_completion.install "priv/shell-completion/fish/rebar3.fish"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
