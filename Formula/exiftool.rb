# exiftool: Build a bottle for Linux
class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-11.85.tar.gz"
  sha256 "8b0aaa8e080adfc8736c3b179c140ad3c05dc58a84540f1e56772ce129a8f897"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0d05e8e55257a5132ffbc91bc4789d2828912f8df54ebbfbbe120d9c808d0c9" => :catalina
    sha256 "d0d05e8e55257a5132ffbc91bc4789d2828912f8df54ebbfbbe120d9c808d0c9" => :mojave
    sha256 "5c2ce26400d6ac9b6b678dfeb845dda3654d8a35be01c1270d8a0216bcb3dd56" => :high_sierra
    sha256 "b457a0d161b0e76848da576c624bfb2cdc4d81b1a68be05338033083a4259584" => :x86_64_linux
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$exeDir/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    man1.install "blib/man1/exiftool.1#{OS.mac? ? "" : "p"}"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
