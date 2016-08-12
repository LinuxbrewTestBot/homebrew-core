class Dhex < Formula
  desc "Ncurses based advanced hex editor featuring diff mode and more"
  homepage "http://www.dettus.net/dhex/"
  url "http://www.dettus.net/dhex/dhex_0.68.tar.gz"
  sha256 "126c34745b48a07448cfe36fe5913d37ec562ad72d3f732b99bd40f761f4da08"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0b10f1a288319a99a878041ab26d3fcae0cc65ed8b0d198091a31cfdf0db1b4" => :x86_64_linux
  end

  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    inreplace "Makefile", "$(DESTDIR)/man", "$(DESTDIR)/share/man"
    bin.mkpath
    man1.mkpath
    man5.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    assert_match("GNU GENERAL PUBLIC LICENSE",
                 pipe_output("#{bin}/dhex -g 2>&1", "", 0))
  end
end
