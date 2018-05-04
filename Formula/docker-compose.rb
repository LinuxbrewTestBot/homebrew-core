# docker-compose: Build a bottle for Linuxbrew
class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.21.2.tar.gz"
  sha256 "3fdaa361dceb919b6008a925b8b672d7402cc3dd8277b8f26b028dd546d39926"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "c295564373993cf84337c084443f4e91856d581d6f69e366d0f0dea0bb7d6338" => :x86_64_linux
  end

  depends_on "python@2"
  depends_on "libyaml"

  # It's possible that the user wants to manually install Docker and Machine,
  # for example, they want to compile Docker manually
  depends_on "docker" => :recommended
  depends_on "docker-machine" => :recommended

  def install
    system "./script/build/write-git-sha" if build.head?
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "docker-compose"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    system bin/"docker-compose", "--help"
  end
end
