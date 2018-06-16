# twarc: Build a bottle for Linuxbrew
class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/96/27/410275915d6c909c2d88b8e17d6ea37135deff3dbd1b2480a2aef92af583/twarc-1.4.7.tar.gz"
  sha256 "ff2485dd77dc726319ed0b303a4bb36901414dd15e7a442de4f2ffedb377ae38"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c85be1480eb7ad3934cb1005b443d23d761b8006fcdf5ee1ac9481720a44618" => :x86_64_linux
  end

  depends_on "python@2"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "twarc"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
