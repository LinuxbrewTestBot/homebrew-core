# ghr: Build a bottle for Linuxbrew
class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.12.1.tar.gz"
  sha256 "d124f7ad2d4bd5be2d6c51ad4d780d69fffc19e41440f7f14bcf2a24d415e006"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "1cb38dd46fc38adda97cee26f0ae38d0defa2aa3eedaf3a4517d3ca304cd9448" => :mojave
    sha256 "33a8801ddcfb493a72775f62e1500e376afe0eec6087499be80c85001cbebe9a" => :high_sierra
    sha256 "659559bd0e30b2164ac4440a77a87861bdd8a5f6de9d938a3b43e9a0910fc7af" => :sierra
    sha256 "70eb2913f8a3db2a6bf063cc3122f22516c914239036cccd816ba16e6581a130" => :x86_64_linux
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/tcnksm/ghr"
    dir.install Dir["*"]
    cd dir do
      # Avoid running `go get`
      inreplace "Makefile", "go get ${u} -d", ""

      system "make", "build"
      bin.install "bin/ghr" => "ghr"
      prefix.install_metafiles
    end
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_include "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
