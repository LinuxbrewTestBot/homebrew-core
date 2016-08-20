# leveldb: Build a bottle for Linuxbrew
class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/v1.19.tar.gz"
  sha256 "7d7a14ae825e66aabeb156c1c3fae9f9a76d640ef6b40ede74cc73da937e5202"

  bottle do
    cellar :any
    sha256 "c89b0511e658167127209752444e7693f01114ee1905eef09aab6e46b49f4a51" => :x86_64_linux
  end

  option "with-test", "Verify the build with make check"

  depends_on "gperftools"
  depends_on "snappy"

  def install
    system "make"
    system "make", "check" if build.bottle? || build.with?("test")

    include.install "include/leveldb"
    bin.install "out-static/leveldbutil"
    lib.install "out-static/libleveldb.a"
    if OS.mac?
      lib.install "out-shared/libleveldb.dylib.1.19" => "libleveldb.1.19.dylib"
      lib.install_symlink lib/"libleveldb.1.19.dylib" => "libleveldb.dylib"
      lib.install_symlink lib/"libleveldb.1.19.dylib" => "libleveldb.1.dylib"
      system "install_name_tool", "-id", "#{lib}/libleveldb.1.dylib", "#{lib}/libleveldb.1.19.dylib"
    else
      lib.install Dir["out-shared/libleveldb.so*"]
    end
  end

  test do
    assert_match "dump files", shell_output("#{bin}/leveldbutil 2>&1", 1)
  end
end
