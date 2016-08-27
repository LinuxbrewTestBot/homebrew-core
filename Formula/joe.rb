# joe: Build a bottle for Linuxbrew
class Joe < Formula
  desc "Joe's Own Editor (JOE)"
  homepage "http://joe-editor.sourceforge.net/index.html"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.2/joe-4.2.tar.gz"
  sha256 "bc5da64bc5683ab7b2962a33214b3537ea17ff6528a3c60ba170359e31e86974"

  bottle do
    sha256 "466a611539a2293bf78372b3fb90dbcbe70daa39e3d5b88eb7559de105105617" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Joe's Own Editor v#{version}", shell_output("TERM=tty #{bin}/joe -help")
  end
end
