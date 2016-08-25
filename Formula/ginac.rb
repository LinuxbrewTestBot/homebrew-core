# ginac: Build a bottle for Linuxbrew
class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "http://www.ginac.de/"
  url "http://www.ginac.de/ginac-1.6.7.tar.bz2"
  sha256 "cea5971b552372017ea654c025adb44d5f1b3e3ce0a739da2fe95189572b85db"

  bottle do
    cellar :any
    sha256 "edcee11a495e8673f9e0136ea9559425a502c9ddc56c7b8370e70ff047c890d9" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "readline"
  depends_on :python unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
    #include <iostream>
    #include <ginac/ginac.h>
    using namespace std;
    using namespace GiNaC;

    int main() {
      symbol x("x"), y("y");
      ex poly;

      for (int i=0; i<3; ++i) {
        poly += factorial(i+16)*pow(x,i)*pow(y,2-i);
      }

      cout << poly << endl;
      return 0;
    }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}",
                                "-L#{Formula["cln"].lib}",
                                "-lcln", "-lginac", "-o", "test"
    system "./test"
  end
end
