# pgformatter: Build a bottle for Linuxbrew
class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v3.4.tar.gz"
  sha256 "1e504e67032d35ab6418a582cb106239e6a78a3fac75a5996db3bdb998d96889"

  bottle do
    cellar :any_skip_relocation
    sha256 "864f59b8b06cc4b53bd6650c47c9ad759cdbd1e88dda66769a620f1447b9d27a" => :mojave
    sha256 "24abc2f70cc5a221bd25b641a90d95dcb439cfc30e0739ed82e198155234cc96" => :high_sierra
    sha256 "c2d42dd09ee6494902cace6bfe0cf204f0246ddaaf70c80095fbbcb22f83f3f0" => :sierra
    sha256 "326d51deb1b8be4b6fc154b29097b3be30748e5f803852e5a1f61f207fffa911" => :x86_64_linux
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    prefix.install (buildpath/"usr/local").children
    (libexec/"lib").install "blib/lib/pgFormatter"
    libexec.install bin/"pg_format"
    bin.install_symlink libexec/"pg_format"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
