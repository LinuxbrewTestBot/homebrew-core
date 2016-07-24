# parallel: Build a bottle for Linuxbrew
class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20160622.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20160622.tar.bz2"
  sha256 "afca50eb4711f60bb3e52efb2fc02bf9ec77d0b9f7989df306ab5ec5577ab6ab"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "29e81004e1c5f95ed6d808b94c154e1b7a6417a3a2dc3dd5c1fa9e8fb840977a" => :x86_64_linux
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
