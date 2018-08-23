class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v7.1.tar.gz"
  sha256 "b7922443fa0e5be08adc2e67e141886466c98a1706bf4e9175b1ef114aeb432b"

  bottle do
    cellar :any
    sha256 "42a7e92a2cd5a1e03ca160ff1a65084ac1f0bbfb61e8e4c56cffdfdc110a2d5a" => :high_sierra
    sha256 "3a3341cfa265da8eff8dd6fc8c1f52b826c26d6e585432db41cbde209cb30c85" => :sierra
    sha256 "7180bf9d8e18df23aadb480dad59840fce8f6a3bbc32a88c80bdaa80f370d6e3" => :el_capitan
    sha256 "f9c0a534088f988ea2f76bef687a977690f7a0d6cb0a71bfd2b932b540bd7ab2" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
