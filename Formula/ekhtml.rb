# ekhtml: Build a bottle for Linuxbrew
class Ekhtml < Formula
  desc "Forgiving SAX-style HTML parser"
  homepage "http://ekhtml.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ekhtml/ekhtml/0.3.2/ekhtml-0.3.2.tar.gz"
  sha256 "1ed1f0166cd56552253cd67abcfa51728ff6b88f39bab742dbf894b2974dc8d6"

  bottle do
    cellar :any
    sha256 "d606a2fe3d466a5e76f22a0736f0b485be613bad4a09575d496d9396d3a71903" => :el_capitan
    sha256 "450e3decaf7077d771f4a5eb43047c820867b17bffb312b039be8b1a33a81611" => :yosemite
    sha256 "4ae02f9ef463d52c8c0c7bccfd3f63441258a89a976f2869bf416b408fc534f3" => :mavericks
    sha256 "79205418065a2c160a0d0d7ca7d2f1f93e4a476027a144f5901e6a06ed71ce4b" => :x86_64_linux
  end

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
