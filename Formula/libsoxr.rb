# libsoxr: Build a bottle for Linuxbrew
class Libsoxr < Formula
  desc "High quality, one-dimensional sample-rate conversion library"
  homepage "https://sourceforge.net/projects/soxr/"
  url "https://downloads.sourceforge.net/project/soxr/soxr-0.1.2-Source.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libs/libsoxr/libsoxr_0.1.2.orig.tar.xz"
  sha256 "54e6f434f1c491388cd92f0e3c47f1ade082cc24327bdc43762f7d1eefe0c275"

  bottle do
    cellar :any
    sha256 "55fd913abd961958bd99944771851f1f1bcabbf2c58751fa1a6e718144c9b1a6" => :x86_64_linux
  end

  depends_on "cmake" => :build

  conflicts_with "sox", :because => "Sox contains soxr. Soxr is purely the resampler."

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
