# algernon: Build a bottle for Linux
class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon.git",
      :tag      => "1.12.6",
      :revision => "da249c53d427c4cde18f758b2e04ea6ce955e825"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa20b282e2ae3d81dc7241a35a4f4cb2f94ec6252426adbe817b31d4738a1d75" => :catalina
    sha256 "21cd4660fbaf3cf7ed98429dfb90d14ca88f11a7f728b46cde79019dbbb02540" => :mojave
    sha256 "7496c47f6ea70bd68e074f1ffbfac585b45faba59d94b706dd2ea57e2388508f" => :high_sierra
    sha256 "aeb868a36d0f54d98f7614984b66284019a49cfe4ab0b0a747b4ce49d9e132f4" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-mod=vendor", "-o", bin/"algernon"

    bin.install "desktop/mdview"
    prefix.install_metafiles
  end

  test do
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":45678"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:45678")
    assert_match /200 OK.*Server: Algernon/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
