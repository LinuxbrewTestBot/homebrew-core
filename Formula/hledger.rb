require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.15.2/hledger-1.15.2.tar.gz"
  sha256 "3d62b1c948ed9bf826a1250098d20c22b3de876993f3089a9ee4a6505091b79a"

  bottle do
    cellar :any_skip_relocation
    sha256 "538e946ba6dbe3102a4d13aec532685a151dd40653ed2dd08965886230ed2431" => :mojave
    sha256 "ec183c76ea4d687ed79cce0024087506a00f95af1a7c39774dd91fa88067dfeb" => :high_sierra
    sha256 "c9e3cf75046e98b65e04055b7f2b96eb3c441d031e4f9d28b01485275886a618" => :sierra
    sha256 "5e68e6c07cc93740c4cc61b47f502488dd8c8fa29e993d56b51f2bd1af4995f0" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  if OS.mac?
    depends_on "ghc" => :build
  else
    depends_on "ghc@8.6" => :build
  end
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger_web" do
    url "https://hackage.haskell.org/package/hledger-web-1.15/hledger-web-1.15.tar.gz"
    sha256 "837f527c7e611c1f2830a37314076825bd2c8f7364439860fe8a7e1736aaa4d4"
  end

  resource "hledger_ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.15/hledger-ui-1.15.tar.gz"
    sha256 "38e8c1ad6e7076345914dfc0df3f0801713550fa80343b6130b8dfd363d5fa10"
  end

  def install
    install_cabal_package "hledger", "hledger-web", "hledger-ui", :using => ["happy", "alex"]
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-web", "--version"
    system "#{bin}/hledger-ui", "--version"
  end
end
