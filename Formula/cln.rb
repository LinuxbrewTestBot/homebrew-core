# cln: Build a bottle for Linuxbrew
class Cln < Formula
  desc "Class Library for Numbers"
  homepage "http://www.ginac.de/CLN/"
  url "http://www.ginac.de/CLN/cln-1.3.4.tar.bz2"
  sha256 "2d99d7c433fb60db1e28299298a98354339bdc120d31bb9a862cafc5210ab748"

  bottle do
    cellar :any
    revision 1
    sha256 "26c953a9f756d021e266d1c84ff2b15feeeb9874d8d56100713776d7260fb5f2" => :x86_64_linux
  end

  option "without-test", "Skip compile-time checks (Not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    assert_match "3.14159", shell_output("#{bin}/pi 6")
  end
end
