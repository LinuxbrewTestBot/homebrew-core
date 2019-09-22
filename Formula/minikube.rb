class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://github.com/kubernetes/minikube"
  url "https://github.com/kubernetes/minikube/archive/v1.4.0.tar.gz"
  sha256 "091f76e5f0c086261e617f8b1c63009a1732bd5d7b559810572ac473e6da0411"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "f29d984869d527c0514b802b1e55a64b4e30b271c3bcd81e26a2e880a3dd538d" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV.deparallelize
    ENV["GOOS"] = "linux"
    ENV["GOARCH"] = "amd64"

    system "make"
    bin.install "out/minikube"
  end

  test do
    assert_match("config modifies minikube config files using subcommands like \"minikube config set vm-driver kvm\"", shell_output("#{bin}/minikube config"))
  end
end
