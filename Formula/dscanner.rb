# dscanner: Build a bottle for Linuxbrew
class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.5.1",
      :revision => "6ca59c71a2d0d7355eb43bdbb2ace60e43208718"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "5c5ac9206432eb10c4ad22600fc58955a20d1f67e9e734690bb22315013bf6ee" => :x86_64_linux
  end

  depends_on "dmd" => :build

  def install
    system "make", "dmdbuild"
    bin.install "bin/dscanner"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main(string[] args)
      {
        writeln("Hello World");
      }
    EOS

    assert_match(/test.d:\t28\ntotal:\t28\n/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
