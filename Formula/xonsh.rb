# xonsh: Build a bottle for Linuxbrew
class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.4.tar.gz"
  sha256 "e303edfe0d1d65ec4f40af5b9f59b866709269cb917472f6362738d854f18765"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aae32d9a3291aa70ea176762dd7a352d5964817b75ccc736b60d4ca36d9be5ea" => :x86_64_linux
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
