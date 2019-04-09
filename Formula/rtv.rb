# rtv: Build a bottle for Linuxbrew
class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.26.0.tar.gz"
  sha256 "1e3c20fdbda2a1f1b584194a36895d8e42aba527b2e9fa7be8ff7fd79c8bee85"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "5c6e84e7021b748a2d2e763b22aec9ec04b92a2dbad74f4b95d5ada3a18ad733" => :mojave
    sha256 "1ec04997bca5a311edf8451907c9f3e1400da2606858a025276c81f167446012" => :high_sierra
    sha256 "2ecdfa0d308a52c4f63c71f3a3f01467c4839f9991cae1099a9e6664fc3910f1" => :sierra
    sha256 "c560c2bb839f437c1d962e3fc8d5e181b422ac0929e8e7aaffc0c41ce8125c26" => :x86_64_linux
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
