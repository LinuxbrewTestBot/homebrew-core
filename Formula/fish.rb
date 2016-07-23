# fish: Build a bottle for Linuxbrew
# fish: Build a bottle for Linuxbrew
class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://fishshell.com/files/2.3.1/fish-2.3.1.tar.gz"
  mirror "https://github.com/fish-shell/fish-shell/releases/download/2.3.1/fish-2.3.1.tar.gz"
  sha256 "328acad35d131c94118c1e187ff3689300ba757c4469c8cc1eaa994789b98664"

  bottle do
    sha256 "a254df0acaa75665386f6009ba9e5ba379c8de115b478c06713c7a601d04b2d6" => :x86_64_linux
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "doxygen" => :build
  end

  depends_on "pcre2"
  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    system "autoconf" if build.head? || build.devel?
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    system "./configure", "--prefix=#{prefix}", ("SED=/usr/bin/sed" if OS.mac?)
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells.

    Then run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
