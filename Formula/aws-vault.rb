class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v4.6.4.tar.gz"
  sha256 "58f71cc7acd7bfbe8d2fce7ae330998b6f1ef065e1ec78070a54c609b1b34118"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7099a8cd531c0d74663fa19c6b3ffaebde41c0df5296625dd8944c0a9e957c7" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "linux"
    ENV["GOARCH"] = "amd64"

    flags = "-X main.Version=#{version} -s -w"

    system "go", "build", "-ldflags=#{flags}"
    bin.install "aws-vault"

    zsh_completion.install "completions/zsh/_aws-vault"
    bash_completion.install "completions/bash/aws-vault"
  end

  test do
    assert_match("aws-vault: error: required argument 'profile' not provided, try --help", shell_output("#{bin}/aws-vault login 2>&1", 1))
  end
end
