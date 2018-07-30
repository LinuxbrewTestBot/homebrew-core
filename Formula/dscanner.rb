# dscanner: Build a bottle for Linuxbrew
class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
      :tag => "v0.5.8",
      :revision => "aa2a76f66b8ccaab5f6371989d34487bb5cf9d9c"
  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    sha256 "82f4f4431c569e21ab2d340c749fbae7f65a09dfcbc29822d7599ed9eff5c4d8" => :high_sierra
    sha256 "9191d8114416f8629e8ad43c1676c90e15f866092c1cb8cea7edd15e8e03c22e" => :sierra
    sha256 "2437e819fac2bfec60117af405ec3df43fa7ae29a71b22b6e5795c0b627d5d5e" => :el_capitan
    sha256 "5b968b2cfb5e897f02ca2f23372de3e86c2c5b655fd6fc5bb3e0b9c95272927a" => :x86_64_linux
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
