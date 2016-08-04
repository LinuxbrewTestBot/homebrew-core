# fibjs: Build a bottle for Linuxbrew
class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/en/index.html"
  url "https://github.com/xicilion/fibjs/releases/download/v0.2.1/fullsrc.zip"
  version "0.2.1"
  sha256 "914d79bb18e5309228747d73c481c1c243db8cc0ab1b29ec66f201cc2d8f85b9"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4503bb65962d4e58d486c87153ebc68063e8f9e4dc4e6cb4166e9d3761cdc1fb" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "./build", "release", "-j#{ENV.make_jobs}"
    bin.install "bin/#{OS::NAME.capitalize}_amd64_release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end
