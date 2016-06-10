# sgrep: Build a bottle for Linuxbrew
class Sgrep < Formula
  desc "Search SGML, XML, and HTML"
  homepage "https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html"
  url "ftp://ftp.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.94a.tar.gz"
  mirror "https://fossies.org/linux/misc/sgrep-1.94a.tar.gz"
  sha256 "d5b16478e3ab44735e24283d2d895d2c9c80139c95228df3bdb2ac446395faf9"

  bottle do
    sha256 "089890a739b047b429b88a583f71832fbfbd3c8f7abc067531424c14e8463df4" => :el_capitan
    sha256 "a4228a3f40db355cbd6b3feedd4cbdaf8c9b582b24f188982f296b17ac14590f" => :yosemite
    sha256 "f582b8ae918c1f279e1e3c362d016ad91aeb4accc229cfe9f6ccac8c991ce4a6" => :mavericks
    sha256 "dbf2f9c61f22570f8a97616bf733605a52caa261d5275e5b9c7c89aac77d9124" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--datadir=#{share}/sgrep"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.eps")
    assert_equal "2", shell_output("#{bin}/sgrep -c '\"mark\"' #{input}").strip
  end
end
