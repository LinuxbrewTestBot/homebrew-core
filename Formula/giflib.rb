# giflib: Build a bottle for Linux
class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.2.1.tar.gz"
  sha256 "31da5562f44c5f15d63340a09a4fd62b48c45620cd302f77a6d9acf0077879bd"

  bottle do
    cellar :any
    sha256 "ad97d175fa77f7afb4a1c215538d8ae9eff30435de7feaa6a5d2e29fca7fef4d" => :catalina
    sha256 "42d2f8a6e9dbf9d4c22a2e64581c7170cc7dcb2a0e66df383efc67b7bc96238d" => :mojave
    sha256 "e1a30a20ad93cd9ec003027d7fba43a7e04ced0bff4156614818cccfc9dec6c9" => :high_sierra
  end

  # Upstream has stripped out the previous autotools-based build system and their
  # Makefile doesn't work on macOS. See https://sourceforge.net/p/giflib/bugs/133/
  patch :p0 do
    url "https://sourceforge.net/p/giflib/bugs/_discuss/thread/4e811ad29b/c323/attachment/Makefile.patch"
    sha256 "a94e7bdd8840a31cecacc301684dfdbf7b98773ad824aeaab611fabfdc513036"
  end

  def install
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end
