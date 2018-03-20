# pandoc: Build a bottle for Linuxbrew
require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.1.3/pandoc-2.1.3.tar.gz"
  sha256 "4e0e9a891293f71a0d1309bbc5736e27601761888d9785ee19d8a4649b047008"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "17a14b46d16948edb720e6246bc99015d7728b43ccbc39c9fccc4fb1726f8972" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  unless OS.mac?
    depends_on "unzip" => :build # for cabal install
    depends_on "zlib"
  end

  def install
    cabal_sandbox do
      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      install_cabal_package *args
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
