# abi-compliance-checker: Build a bottle for Linuxbrew
class AbiComplianceChecker < Formula
  desc "Check binary and source compatibility for C/C++"
  homepage "http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
  url "https://github.com/lvc/abi-compliance-checker/archive/1.99.22.tar.gz"
  sha256 "da8d9c4f1d35d1ee355263b7f1b59c869e02fcb7cb764a695f8c730ce3dd5c2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b3379f3b65e6c1dafbfa39c33d3aff33e957f4f5094608a708d42b212c28c9c" => :x86_64_linux
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
