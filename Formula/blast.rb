class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.7.1+-src.tar.gz"
  version "2.7.1"
  sha256 "10a78d3007413a6d4c983d2acbf03ef84b622b82bd9a59c6bd9fbdde9d0298ca"
  revision 1 unless OS.mac?

  bottle do
    rebuild 1
    sha256 "3765d02c4d98ac0a66518cbc049a57ede1f2f5c2633e79ea2630cf8742213102" => :x86_64_linux
  end

  depends_on "lmdb"
  unless OS.mac?
    depends_on "cpio" => :build
    depends_on "bzip2"
    depends_on "zlib"
  end

  conflicts_with "proj", :because => "both install a `libproj.a` library"

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    cd "c++" do
      # Use ./configure --without-boost to fix
      # error: allocating an object of abstract class type 'ncbi::CNcbiBoostLogger'
      # Boost is used only for unit tests.
      # See https://github.com/Homebrew/homebrew-science/pull/3537#issuecomment-220136266
      system "./configure", "--prefix=#{prefix}",
                            "--without-debug",
                            "--without-boost"

      # Fix the error: install: ReleaseMT/lib/*.*: No such file or directory
      system "make"

      system "make", "install"
    end
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/blastn -query test.fasta -subject test.fasta")
    assert_match "Identities = 70/70", output
  end
end
