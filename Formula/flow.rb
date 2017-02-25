class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.40.0.tar.gz"
  sha256 "f09b9191734f7245f906884be57266d24993a5533a68b3ad8ec9992c77ea1230"
  head "https://github.com/facebook/flow.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    prefix "/home/linuxbrew/.linuxbrew"
    cellar :any_skip_relocation
    sha256 "cffe521958aefa94366b04f1377a9a4d2d0ee6032aadafecbf176eb7d0589a8a" => :x86_64_linux
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "elfutils" unless OS.mac?

  def install
    system "make"
    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
