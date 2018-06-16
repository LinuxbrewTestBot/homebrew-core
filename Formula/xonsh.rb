# xonsh: Build a bottle for Linuxbrew
class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.7.tar.gz"
  sha256 "1ff04ac5aa8a9cfc6d88303bcf9ee304721be27e77ce14978804d9b52f3a1d3c"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37f77b257735ff98169303a677e5aeca2e779876ba8ec122c4af8eb86d6d926f" => :x86_64_linux
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
