class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.io/remake"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.2%2Bdbg-1.4/remake-4.2.1%2Bdbg-1.4.tar.bz2"
  version "4.2.1-1.4"
  sha256 "55df3b2586ab90ac0983a049f1911c4a1d9b68f7715c69768fbb0405e96a0e7b"

  bottle do
    rebuild 1
    sha256 "722bdd9f9f0326a73ac69e56efd7a5a9a15d71db1a7e3076ececa33d27f0a1d7" => :catalina
    sha256 "1c2ca8baa2d831524bc2abb0639d3ad91dd6b96de32863e99f8bba33174b98d1" => :mojave
    sha256 "ad4182037734bbaa6f4627598ba1358fb904d0fdcdebccb73e0dfdc8d2b6c780" => :high_sierra
    sha256 "401d17a938db2e6eb1ebe6aa3cd7a7ce1761ba1e7565cc7c5952e7157a37516e" => :x86_64_linux
  end

  depends_on "readline" unless OS.mac?

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
