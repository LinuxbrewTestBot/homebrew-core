# vault: Build a bottle for Linuxbrew
# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag      => "v0.11.5",
      :revision => "a59ffa4a0f09bbf198241fe6793a96722789b639"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccdd43326edadd365168e929aae2e4da898d65838df3e61dae7892d46eea0a32" => :mojave
    sha256 "250d162042ebd0577625c969f5eef235cb1cabf857b75a8657462e2b6b82f85a" => :high_sierra
    sha256 "ee289fb807fea35118c3f88c2bbbf39ee4accc3efa2c40869b06c2352801eed9" => :sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    (buildpath/"bin").mkpath

    cd "src/github.com/hashicorp/vault" do
      system "make", "dev"
      bin.install "bin/vault"
      prefix.install_metafiles
    end
  end

  test do
    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 1
    ENV.append "VAULT_ADDR", "http://127.0.0.1:8200"
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end
