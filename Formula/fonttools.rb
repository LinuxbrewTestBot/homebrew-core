# fonttools: Build a bottle for Linuxbrew
class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.26.0/fonttools-3.26.0.zip"
  sha256 "a5c35273ce972e0dd26efba9f84e0488053ab0ebcb29c4de37eb3a3669254a23"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcd93a0e9001d318bb658515db224513e43cc19a0f5d9513a6bd3e149e20d0c4" => :x86_64_linux
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python@2"
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    unless OS.mac?
      assert_match "usage", shell_output("#{bin}/ttx -h")
      return
    end
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
