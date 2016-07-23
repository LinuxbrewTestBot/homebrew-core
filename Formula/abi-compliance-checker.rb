# abi-compliance-checker: Build a bottle for Linuxbrew
class AbiComplianceChecker < Formula
  desc "Check binary and source compatibility for C/C++"
  homepage "http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
  url "https://github.com/lvc/abi-compliance-checker/archive/1.99.21.tar.gz"
  sha256 "c9ca13a9a7a0285214f9a18195efae57a99465392fbf05fdc4a15fceada4dedf"

  bottle do
    cellar :any_skip_relocation
    sha256 "c519b5b42aa70951f98141615d5c3270b8081494be5b12a93eeda5f2e1010b06" => :x86_64_linux
  end

  depends_on "ctags"
  depends_on "gcc" => :run

  def install
    system "perl", "Makefile.pl", "-install", "--prefix=#{prefix}"
    rm bin/"abi-compliance-checker.cmd" if OS.mac?
  end

  test do
    (testpath/"test.xml").write <<-EOS.undent
      <version>1.0</version>
      <headers>#{Formula["ctags"].include}</headers>
      <libs>#{Formula["ctags"].lib}</libs>
    EOS
    gcc_suffix = Formula["gcc"].version.to_s.slice(/\d/)
    system bin/"abi-compliance-checker", "-cross-gcc", "gcc-" + gcc_suffix,
                                         "-lib", "ctags",
                                         "-old", testpath/"test.xml",
                                         "-new", testpath/"test.xml"
  end
end
