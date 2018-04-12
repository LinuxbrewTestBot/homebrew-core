# sops: Build a bottle for Linuxbrew
class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.0.3.tar.gz"
  sha256 "90da5ae9c76c39794cd35cb93a77d24b60b4c4bb55ef8abde95f44991290218c"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa8cbfd43154b3511caa88f1fedd25d335592304891b6565a1b04f9e52f836e9" => :high_sierra
    sha256 "674a7a6966646fd04bf7ce4a38406820d4bb1a8a0a683f3654f3ddd3d32b3f75" => :sierra
    sha256 "f99d3db5b21b95900f814f10639cab492ca8a234da808d250bb413f4db9a63c1" => :el_capitan
    sha256 "ec7cbf75225b9f1ee7d3f0acab51d16b29ce188c44b18724421f9e08114b59b2" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/go.mozilla.org").mkpath
    ln_s buildpath, "src/go.mozilla.org/sops"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version 2>&1")
  end
end
