# gsoap: Build a bottle for Linuxbrew
class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.66.zip"
  sha256 "ef7a7ebf3963922ebc97424a6b2371b3761581f3fd07ecfdbaf8a36a8df63d59"

  bottle do
    sha256 "b605e4c6dfc849d742d01a49b04261c6e29a7ae031f0b1a14144a0dac7ccb8fc" => :x86_64_linux
  end

  depends_on "openssl"
  unless OS.mac?
    depends_on "bison"
    depends_on "flex"
  end

  def install
    # Contacted upstream by email and been told this should be fixed by 2.8.37,
    # it is due to the compilation of symbol2.c and soapcpp2_yacc.h not being
    # ordered correctly in parallel.
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end
