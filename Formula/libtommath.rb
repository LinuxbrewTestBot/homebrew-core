# libtommath: Build a bottle for Linuxbrew
class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.1.0/ltm-1.1.0.tar.xz"
  sha256 "90466c88783d1fe9f5c2364a69f5479f10d73ed616011be6196f35f7f1537ead"
  head "https://github.com/libtom/libtommath.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "e69fa7fa3b1ff2e85209b6719ad17192942c9d2954321f30b7e039745e4e9ffb" => :mojave
    sha256 "291e7d5f7f5ecace41fc8d9a402f8bb630004700f264339ad013df713f9b33eb" => :high_sierra
    sha256 "fba7bbbc5efe8f09f7a23b93e5d168134703f3ce14bf2a5b8b7473cad0f7826f" => :sierra
    sha256 "690eb2d8b8264d5c2471b187bd6e87cc8eb11c95103876365a04f7b0294a9aab" => :x86_64_linux
  end

  def install
    ENV["DESTDIR"] = prefix

    system "make"
    system "make", "test_standalone"
    include.install Dir["tommath*.h"]
    lib.install "libtommath.a"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
