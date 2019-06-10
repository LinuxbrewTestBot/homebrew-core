# boost-bcp: Build a bottle for Linuxbrew
class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.bz2"
  sha256 "430ae8354789de4fd19ee52f3b1f739e1fba576f0aded0897c3c2bc00fb38778"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8bc92d0fd7a062612c2e19ea8993b30ba583fb92a4bc45467092dca5e93bca4" => :mojave
    sha256 "dba120d947a05ceed5a225c23a2a67dd97c4fbffcf45e45c19bd47cad0730a2a" => :high_sierra
    sha256 "d2f3b79542144ebc71b239084a5bab68d6aef7637d7545fa8e70d14eea5e98ee" => :sierra
    sha256 "c5d3a12777ac0d12d8439d81fada07c52482ac57246d6eb2436751e313aaff01" => :x86_64_linux
  end

  depends_on "boost-build" => :build

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--help"
  end
end
