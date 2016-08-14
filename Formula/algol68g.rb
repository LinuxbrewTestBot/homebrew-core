# algol68g: Build a bottle for Linuxbrew
class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-2.8.3.tar.gz"
  sha256 "568bc93950463f8a70c3973097360945a4dfb300c422a8410cfc638d6ba548e7"

  bottle do
    sha256 "b25004995ba6e5af9079273b0e36d55caf70178530f1495deafbedefa830ad2a" => :x86_64_linux
  end

  depends_on "gsl" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<-EOS.undent
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
