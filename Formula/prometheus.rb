# prometheus: Build a bottle for Linuxbrew
class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.3.1.tar.gz"
  sha256 "3aab85d3cb59540b6b43f5a80b14d13937fc0d51e8e82a29f0efebf6addd5f75"

  bottle do
    cellar :any_skip_relocation
    sha256 "79c5e53cb8635410bccbdcae10dd318d0474f600e3337211be299d4d82c7f182" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "build"
    bin.install %w[promtool prometheus]
    libexec.install %w[consoles console_libraries]
  end

  test do
    (testpath/"rules.example").write <<~EOS
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    EOS
    system "#{bin}/promtool", "check", "rules", testpath/"rules.example"
  end
end
