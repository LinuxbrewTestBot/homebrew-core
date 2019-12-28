class Sampler < Formula
  desc "Tool for shell commands execution, visualization and alerting"
  homepage "https://sampler.dev"
  url "https://github.com/sqshq/sampler/archive/v1.1.0.tar.gz"
  sha256 "8b60bc5c0f94ddd4291abc2b89c1792da424fa590733932871f7b5e07e7587f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b4a4c841691d8a6ca9ea4649092684511bff1f60d7d80e364db13115f2e6399" => :catalina
    sha256 "b50240b4f199da6d55d4645dfd3d2b0fc3406d20a504ba9af4d3b545196438b1" => :mojave
    sha256 "163b575ff369f264605bdc69c0fc838e44e706f8b6c527bb343cbfb18a9b1fdc" => :high_sierra
    sha256 "f3a60c290fb91e2a621778e53865d71808db100e5590c114792c5c20687645ff" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "alsa-lib" unless OS.mac?

  def install
    system "go", "build", "-o", bin/"sampler"
  end

  test do
    assert_includes "specify config file", shell_output("#{bin}/sampler")
  end
end
