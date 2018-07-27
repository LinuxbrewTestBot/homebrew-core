# flow: Build a bottle for Linuxbrew
class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.77.0.tar.gz"
  sha256 "30d176bc9a88687b9ea605f3bc8aa3e97100984a71f883173e033634d9aa3e6e"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2d4019a08cb48f5c45aeb31967e56f68ef471bbc288e18ff428d0bf76498f72" => :high_sierra
    sha256 "db580f767098bece8c665da62da3793a9861ec5e00198f1354f8b76936e1b37b" => :sierra
    sha256 "ff85303887f4ff849994985766b613d98673109b5221179dbd3a22149c783aae" => :el_capitan
    sha256 "0a3ae2ec1cd5550eb5884ad1ac3e53910b79635c7db1e27be7c19c24fc427f26" => :x86_64_linux
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  unless OS.mac?
    depends_on "m4" => :build
    depends_on "rsync" => :build
    depends_on "unzip" => :build
    depends_on "elfutils"
  end

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
