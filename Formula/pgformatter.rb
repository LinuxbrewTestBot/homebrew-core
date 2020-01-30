# pgformatter: Build a bottle for Linux
class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v4.2.tar.gz"
  sha256 "54780782d74ca1c8b3a183c53a7a95a8cc8789ddb3690f757c7e992d1cc364a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7af4ea0fb76eaf00600648b08e4c12d93ecacbb0b7886233117a5aa5f6181eb" => :catalina
    sha256 "b7af4ea0fb76eaf00600648b08e4c12d93ecacbb0b7886233117a5aa5f6181eb" => :mojave
    sha256 "3fa7887f4c73c61c23a3bb535042849f3db128adbf4f63c7d5ced622c3d284e0" => :high_sierra
    sha256 "6a833c1e346f8068462a9155ae33b7afccafc08e780ce851346d655c5ffb780f" => :x86_64_linux
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    unless OS.mac?
      mkdir "usr/local/share"
      mv "usr/local/man", "usr/local/share"
    end
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
