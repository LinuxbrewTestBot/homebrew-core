class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.18.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.18.tar.gz"
  sha256 "b8822cb4769e2d759c828c06f196614936c88c141c3132b18252fe25c2b635ce"

  bottle do
    cellar :any
    sha256 "170273e1f15c2072f3ecd0fdd07c401780e839a9b52467aae7566dcfbd05a1d9" => :mojave
    sha256 "8fff772638744417c4ff4794915f040d329f0406fbb807fa1320025deb3236f5" => :high_sierra
    sha256 "114bf9b606f3801a8d6e553185503031342c803d92b423c4dcc94f6a973930d7" => :sierra
    sha256 "115eabe29f9a47c93808e8670f0a5d8209bad4926947596d5c587a4db7cce0a0" => :el_capitan
    sha256 "38d53dfd94013f952dd53081e49cb9ca901ab465ad91bf92881b93087e9e3622" => :x86_64_linux
  end

  if OS.mac?
    option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."
  else
    option "without-libgdbm-compat", "Do not build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."
  end

  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --without-readline
      --prefix=#{prefix}
    ]

    args << "--enable-libgdbm-compat" if build.with? "libgdbm-compat"

    # GDBM uses some non-standard GNU extensions,
    # enabled with -D_GNU_SOURCE.  See:
    #   https://patchwork.ozlabs.org/patch/771300/
    #   https://stackoverflow.com/questions/5582211
    #   https://www.gnu.org/software/automake/manual/html_node/Flag-Variables-Ordering.html
    #
    # Fix error: unknown type name 'blksize_t'
    args << "CPPFLAGS=-D_GNU_SOURCE" unless OS.mac? || build.bottle?

    system "./configure", *args
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
