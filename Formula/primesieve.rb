# primesieve: Build a bottle for Linuxbrew
class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v7.4.tar.gz"
  sha256 "ff9b9e8c6ca3b5c642f9a334cc399dd55830a8d9c25afd066528aa2040032399"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    sha256 "c932276f2380adb0931435638641dcce166d2ab542ec7254a6fc4257b9b2f259" => :mojave
    sha256 "799b34ea32419dd37598adeaac9b6b779351cfd91a3dba99c122ba3b518e5a04" => :high_sierra
    sha256 "afdbe6ecf6907a23e1e1b20ec5f24293063cb246cb9da2ff903b353e6604ba28" => :sierra
    sha256 "2fdb03ac5ccb09922c93702fe4ea9b3d31a446ceff5ff3a80da341461b79fa39" => :x86_64_linux
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
