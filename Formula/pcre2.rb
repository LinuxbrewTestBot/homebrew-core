# pcre2: Build a bottle for Linuxbrew
class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.22.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre2/10.21/pcre2-10.22.tar.bz2"
  sha256 "b2b44619f4ac6c50ad74c2865fd56807571392496fae1c9ad7a70993d018f416"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    sha256 "431ea507b68e3e82fbf10cae44fc849bd518936454fdd87f87a733d81ac9bb29" => :x86_64_linux
  end

  option :universal

  depends_on "bzip2" unless OS.mac?

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
