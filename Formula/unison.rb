# unison: Build a bottle for Linuxbrew
class Unison < Formula
  desc "Unison file synchronizer"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.48.4.tar.gz"
  sha256 "30aa53cd671d673580104f04be3cf81ac1e20a2e8baaf7274498739d59e99de8"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e5cf55bc10b9a1735cee1d005c32ca326e6ded66fe47d483e282d2fb36f980c" => :x86_64_linux
  end

  depends_on "ocaml" => :build

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make ./mkProjectInfo"
    system "make UISTYLE=text"
    bin.install "unison"
  end
end
