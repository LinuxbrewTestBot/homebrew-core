class Liblacewing < Formula
  desc "Cross-platform, high-level C/C++ networking library"
  homepage "http://lacewing-project.org/"
  url "https://github.com/udp/lacewing/archive/0.5.4.tar.gz"
  sha256 "c24370f82a05ddadffbc6e79aaef4a307de926e9e4def18fb2775d48e4804f5c"
  revision 1
  head "https://github.com/udp/lacewing.git"

  bottle do
    cellar :any
    revision 3
    sha256 "da3e271eb04bd4d59d7e1b5465403a00259b20e7be903b4e0032dcea6fac9c76" => :x86_64_linux
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    # https://github.com/udp/lacewing/issues/104
    mv "#{lib}/liblacewing.dylib.0.5", "#{lib}/liblacewing.0.5.dylib" if OS.mac?
  end
end
