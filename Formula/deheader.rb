class Deheader < Formula
  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.6.tar.gz",
      :using => :nounzip
  sha256 "3b99665c4f0dfda31d200bf2528540d6898cb846499ee91effa2e8f72aff3a60"
  head "https://gitlab.com/esr/deheader.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b70a9eb18042a3e93ab8fc1bf018c417d8b41f9b8efe6d818d45aed6922cf52" => :sierra
    sha256 "2b70a9eb18042a3e93ab8fc1bf018c417d8b41f9b8efe6d818d45aed6922cf52" => :el_capitan
    sha256 "2b70a9eb18042a3e93ab8fc1bf018c417d8b41f9b8efe6d818d45aed6922cf52" => :yosemite
    sha256 "a8e0f9dbb9facba1035da6d491a2b4cb150a5fd78da8b8e34939f04a01bfac19" => :x86_64_linux
  end

  depends_on "xmlto" => :build
  depends_on "libarchive" => :build unless OS.mac?

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Remove for > 1.6
    # Fix "deheader-1.6/deheader.1: Can't create 'deheader-1.6/deheader.1'"
    # See https://gitlab.com/esr/deheader/commit/ea5d8d4
    tar = OS.mac? ? "/usr/bin/tar" : Formula["libarchive"].bin/"bsdtar"
    system tar, "-xvqf", "deheader-1.6.tar.gz",
                           "deheader-1.6/deheader.1"
    system tar, "-xvf", "deheader-1.6.tar.gz", "--exclude",
                           "deheader-1.6/deheader.1"
    cd "deheader-1.6" do
      system "make"
      bin.install "deheader"
      man1.install "deheader.1"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <string.h>
      int main(void) {
        printf("%s", "foo");
        return 0;
      }
    EOS
    assert_equal "121", shell_output("#{bin}/deheader test.c | tr -cd 0-9")
  end
end
