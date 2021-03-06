class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v5.1.2.tar.gz"
  sha256 "f8a9ed4164f01e16cf4056336f456cc33669a2d280fb0e5f5a231e7cd5f040fc"
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4b92ef41a216ca97a81b5d3715d24661f7496ce6c8fff33ba318a8826ac8016" => :x86_64_linux
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
