class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v5.0.1.tar.gz"
  sha256 "959dc3daebe42b8dac477371fa501a31f357f22f1d97ed2928cb9ce954582977"
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
    sha256 "29b0524a29b33a43cb2389d13840a5f63023304f0147d4dcee7f9489c25a501c" => :x86_64_linux
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
