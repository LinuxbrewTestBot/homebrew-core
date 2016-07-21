# texinfo: Build a bottle for Linuxbrew
class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftpmirror.gnu.org/texinfo/texinfo-6.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-6.1.tar.xz"
  sha256 "ac68394ce21b2420ba7ed7cec65d84aacf308cc88e9bf4716fcfff88286883d2"

  bottle do
    sha256 "f8befc873f972803f5738fdb10298d800a519a28aeb94c8653ae26274657543f" => :x86_64_linux
  end

  keg_only :provided_by_osx, <<-EOS.undent
    Software that uses TeX, such as lilypond and octave, require a newer version
    of these files.
  EOS

  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  test do
    (testpath/"test.texinfo").write <<-EOS.undent
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match /Hello World!/, File.read("test.info")
  end
end
