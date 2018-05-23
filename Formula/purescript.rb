# purescript: Build a bottle for Linuxbrew
require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://hackage.haskell.org/package/purescript-0.12.0/purescript-0.12.0.tar.gz"
  sha256 "2b0791ac7a069c61fb952fc8c36703d6501af6a2fc78660b0b34e44c7ca67952"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab58d485057829fb2dea8a87762cac68cf642da9e5626160d8e957baf68eef7d" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build
  unless OS.mac?
    depends_on "ncurses"
    depends_on "zlib"
  end

  def install
    cabal_sandbox do
      if build.head?
        cabal_install "hpack"
        system "./.cabal-sandbox/bin/hpack"
      end

      install_cabal_package "-f", "release", :using => ["alex", "happy"]
    end
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~EOS
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end
