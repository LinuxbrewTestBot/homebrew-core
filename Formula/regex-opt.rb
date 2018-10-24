# regex-opt: Build a bottle for Linuxbrew
class RegexOpt < Formula
  desc "Perl-compatible regular expression optimizer"
  homepage "https://bisqwit.iki.fi/source/regexopt.html"
  url "https://bisqwit.iki.fi/src/arch/regex-opt-1.2.4.tar.gz"
  sha256 "128c8ba9570b1fd8a6a660233de2f5a4022740bc5ee300300709c3894413883f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "76b26dc9e766e7a8b0806660e966e3a49c593591b94d90439f89b7cbc797d019" => :mojave
    sha256 "0e46dec5d46b145e32ca597c00c75fea2e7097e57c5d3131be141e5bea2b96db" => :high_sierra
    sha256 "68b5f75c9fdb645334ae8a48a5b7e01620e19d5f103811579cb8bf96101c6ac7" => :sierra
    sha256 "fd31e2648a4c0bb509b4f2424700dfba3386d91083bd37796adc009864f040b0" => :x86_64_linux
  end

  def install
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "regex-opt"
  end

  test do
    output = shell_output("#{bin}/regex-opt foo...*..*bar")
    assert_equal "foo.{3,}bar", output
  end
end
