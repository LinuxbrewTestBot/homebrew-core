# closure-compiler: Build a bottle for Linuxbrew
class ClosureCompiler < Formula
  desc "JavaScript optimizing compiler"
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20160517.tar.gz"
  sha256 "6a7ba4c4e991c6325a53f9505b1b2596b36997c4f75d3f34c3a935f5feeb8410"
  head "https://github.com/google/closure-compiler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8bf6b0c165297eba59c46fe143ee8a83d9815ea0df2e0594eeb3f17a3817b2e" => :x86_64_linux
  end

  depends_on :ant => :build
  depends_on :java => "1.7+"

  def install
    system "ant", "clean"
    system "ant"
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"build/compiler.jar", "closure-compiler"
  end

  test do
    (testpath/"test.js").write <<-EOS.undent
      (function(){
        var t = true;
        return t;
      })();
    EOS
    system bin/"closure-compiler",
           "--js", testpath/"test.js",
           "--js_output_file", testpath/"out.js"
    assert_equal (testpath/"out.js").read.chomp, "(function(){return!0})();"
  end
end
