# serve: Build a bottle for Linuxbrew
class Serve < Formula
  desc "Static http server anywhere you need one"
  homepage "https://github.com/syntaqx/serve"
  url "https://github.com/syntaqx/serve/archive/v0.4.0.tar.gz"
  sha256 "5329738cc72bcee9c7d327981e256369c623257f7f9bd282592deafccacee6f1"
  head "https://github.com/syntaqx/serve.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a339885f14479144ebe771f5caba2239290d89926a1a8bbbaa56751b9ef62f8f" => :mojave
    sha256 "2b1474e49ed747c67fde6ed65e404da4c4e4d2f39190995241e10e62a99cca17" => :high_sierra
    sha256 "c23f691164cbd2f96630d273215f300e1e05ad99427b63e830db52c01eb9ac08" => :sierra
    sha256 "e6e12f8c0d18dae0d1251ab45f2508388750ff748fbf1c74012ac75a2d205978" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/syntaqx/serve"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"serve", "./cmd/serve"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/serve"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match(/200 OK/m, output)
    ensure
      Process.kill("HUP", pid)
    end
  end
end
