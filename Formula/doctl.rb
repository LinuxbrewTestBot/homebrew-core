# doctl: Build a bottle for Linuxbrew
class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.16.0.tar.gz"
  sha256 "975eab4b7f1c3fbf36d27ecf128d8ffbe22cc982732d44d4b1179f84eba0fec9"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "be434fd587e0869e7f18d06c71a8344255732e2f517b0a3bf7077e299bc78843" => :mojave
    sha256 "cbe2c5a68d0a93e16ca2bc358139999e9d514dea674ae50691f4c5d872256139" => :high_sierra
    sha256 "1fa28d891d3f217eb3800d69c62681195a93a7dc2307722e37054d3fc9c1d621" => :sierra
    sha256 "ec641d6104f86a2dc923fdb96481f2130b9ff91ebcb140ad20b01fd1da34273f" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"

    doctl_version = version.to_s.split(/\./)
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{doctl_version[0]}
      #{base_flag}.Minor=#{doctl_version[1]}
      #{base_flag}.Patch=#{doctl_version[2]}
      #{base_flag}.Label=release
    ].join(" ")
    system "go", "build", "-ldflags", ldflags, "github.com/digitalocean/doctl/cmd/doctl"
    bin.install "doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"doctl").write `#{bin}/doctl completion zsh`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
