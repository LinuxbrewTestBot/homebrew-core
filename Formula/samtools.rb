# samtools: Build a bottle for Linuxbrew
class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2"
  sha256 "083f688d7070082411c72c27372104ed472ed7a620591d06f928e653ebc23482"

  bottle do
    cellar :any
    sha256 "c1c3b6b25c052cad33208dc14f1bea183cdf83aa986a66815f9a7a69a1b91d67" => :high_sierra
    sha256 "e349989a4ee48ed6773017282d32d87cfb08d6ff3fab6649889cd84b08351f1b" => :sierra
    sha256 "ec950e5ece42592ba47012de10d754dbfc22d29fee50170495506c88e4e1d05b" => :el_capitan
  end

  depends_on "htslib"
  depends_on "ncurses" unless OS.mac?

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"samtools", "faidx", "test.fasta"
    assert_equal "U00096.2:1-70\t70\t15\t70\t71\n", (testpath/"test.fasta.fai").read
  end
end
