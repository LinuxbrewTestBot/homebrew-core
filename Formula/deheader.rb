# deheader: Build a bottle for Linuxbrew
class Deheader < Formula
  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.3.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/deheader/deheader_1.3.orig.tar.gz"
  sha256 "652c07bf1c7d5da7cf71c9889de11609c8cb2bd0c13122ad424f2c25da9e2e3b"
  head "https://gitlab.com/esr/deheader.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "479b3fd6f2a192e883ac3f6a5b924bbc2b44a894e49220db32445adb1b86ff96" => :x86_64_linux
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "make"
    bin.install "deheader"
    man1.install "deheader.1"
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
