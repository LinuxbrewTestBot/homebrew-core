# aurora: Build a bottle for Linux
class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/xuri/aurora/archive/2.2.tar.gz"
  sha256 "90ac08b7c960aa24ee0c8e60759e398ef205f5b48c2293dd81d9c2f17b24ca42"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "f3b45006b5b5c6f15166d11d1a740fb14f3b22c1d64b3b64397ed2958e9c882d" => :catalina
    sha256 "21abebb582fbac2ebb400328b455c890206f78ae0910f75ded8019bfc6a40c1f" => :mojave
    sha256 "e3e9b06b4b9053afb4b75b48d90555d00fcc8404309d8b2b2b336538810746cb" => :high_sierra
    sha256 "35bc4d2607dbf232b1e8e0e9c6bc14acaa9a5937d522c3fc21fb420dc1a7ed62" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"aurora"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
