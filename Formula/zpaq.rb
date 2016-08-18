# zpaq: Build a bottle for Linuxbrew
class Zpaq < Formula
  desc "Incremental, journaling command-line archiver"
  homepage "http://mattmahoney.net/dc/zpaq.html"
  url "http://mattmahoney.net/dc/zpaq714.zip"
  version "7.14"
  sha256 "7ebd2ecf6b7699cb1c9e02d3045698a71f684f83f48ebc18bad1a7e075b1b5f6"
  head "https://github.com/zpaq/zpaq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc10b51ceb839909c722c6541a163d7c80423090e8e6b09c358609f130851bf1" => :x86_64_linux
  end

  resource "test" do
    url "http://mattmahoney.net/dc/calgarytest2.zpaq"
    sha256 "b110688939477bbe62263faff1ce488872c68c0352aa8e55779346f1bd1ed07e"
  end

  def install
    # Reported 6 Aug 2016 to mattmahoneyfl (at) gmail (dot) com
    # OS X `install` command doesn't have `-t`
    inreplace "Makefile", /(install -m.* )-t (.*) (.*)(\r)/, "\\1 \\3 \\2\\4"
    system "make"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    testpath.install resource("test")
    assert_match "all OK", shell_output("#{bin}/zpaq x calgarytest2.zpaq 2>&1")
  end
end
