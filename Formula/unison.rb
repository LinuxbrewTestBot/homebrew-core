class Unison < Formula
  desc "File-synchronization tool"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "http://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.48.4/unison-2.48.4.tar.gz"
  sha256 "30aa53cd671d673580104f04be3cf81ac1e20a2e8baaf7274498739d59e99de8"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "1b71b8597b738aa915f2ec92d4b92fe01d705915d88317f481f631de96f5d279" => :x86_64_linux
  end

  depends_on "ocaml" => :build

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "./mkProjectInfo"
    system "make", "UISTYLE=text"
    bin.install "unison"
  end

  test do
    system bin/"unison", "-version"
  end
end
