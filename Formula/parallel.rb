# parallel: Build a bottle for Linuxbrew
class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20160722.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20160722.tar.bz2"
  sha256 "e391ebd081e8ba13e870be68106d1beb5def2b001fa5881f46df0ab95304f521"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b7e2ddd1631a4b86b43f845a2209500ee9587b544df86fdf49875578cd7d6f8" => :x86_64_linux
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
