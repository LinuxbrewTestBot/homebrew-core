# htop: Build a bottle for Linuxbrew
class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"
  url "https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz"
  sha256 "179be9dccb80cee0c5e1a1f58c8f72ce7b2328ede30fb71dcdf336539be2f487"

  bottle do
    sha256 "2c44e3de62f62e8b554ff1927a61c8a2cd46e5a8f9add6db98888f26668123b7" => :x86_64_linux
  end

  head do
    url "https://github.com/hishamhm/htop.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-ncurses", "Build using homebrew ncurses (enables mouse scroll)" if OS.mac?

  depends_on "homebrew/dupes/ncurses" => OS.mac? ? :optional : :recommended

  conflicts_with "htop-osx", :because => "both install an `htop` binary"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    htop requires root privileges to correctly display all running processes,
    so you will need to run `sudo htop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    pipe_output("#{bin}/htop", "q", 0)
  end
end
