# the_silver_searcher: Build a bottle for Linuxbrew
class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/1.0.2.tar.gz"
  sha256 "4cb73a4436fccf2c2cae91479a0167bacaa968a4deca28f3ff9d5abd98f01009"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    sha256 "76f78abce8a253d8384428315b560ee06dd997351c0d3609a4f313238d7c2641" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz" => :recommended

  def install
    # Stable tarball does not include pre-generated configure script
    system "aclocal", "-I #{HOMEBREW_PREFIX}/share/aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "--add-missing"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-lzma" if build.without?("xz")

    system "./configure", *args
    system "make"
    system "make", "install"

    bash_completion.install "ag.bashcomp.sh"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/ag", "Hello World!", testpath
  end
end
