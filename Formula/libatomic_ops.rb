# libatomic_ops: Build a bottle for Linuxbrew
class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-7.4.4.tar.gz"
  sha256 "bf210a600dd1becbf7936dd2914cf5f5d3356046904848dcfd27d0c8b12b6f8f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cc062b32d5480381aa6597ffac104b5231609efc0ee488f609e8d3dee632e2e" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
