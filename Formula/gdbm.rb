# gdbm: Build a bottle for Linuxbrew
class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftpmirror.gnu.org/gdbm/gdbm-1.12.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gdbm/gdbm-1.12.tar.gz"
  sha256 "d97b2166ee867fd6ca5c022efee80702d6f30dd66af0e03ed092285c3af9bcea"

  bottle do
    cellar :any
    sha256 "211de22676f77adf5caef736d94fa5b7c5f1f8fd0ac08b35ab015eea67974f0e" => :x86_64_linux
  end

  option :universal
  option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-libgdbm-compat" if build.with? "libgdbm-compat"

    system "./configure", *args
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert File.exist?("test")
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
