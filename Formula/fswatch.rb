# fswatch: Build a bottle for Linuxbrew
class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.11.3/fswatch-1.11.3.tar.gz"
  sha256 "21f60ff255bd8dac72c8eb917b08c10ef2a040b380876a35357f6a860282ac83"

  bottle do
    cellar :any
    sha256 "3690ff441fc3318b46922b404d7e467012218a9afe643045479cfd94008b985d" => :x86_64_linux
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
