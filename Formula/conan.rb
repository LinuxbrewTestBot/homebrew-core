# conan: Build a bottle for Linuxbrew
class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.3.0.tar.gz"
  sha256 "23c7a08af5f62781f1cf5399a0688b77add074d6e7ec0a156f09269fbcaf7c47"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "c02257a821c6a1e8f29fab6f4fbe7507334f5995ce24038e726fadc6e159dd24" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
