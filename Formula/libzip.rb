class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.5.2.tar.gz"
  sha256 "be694a4abb2ffe5ec02074146757c8b56084dbcebf329123c84b205417435e15"
  revision 1 unless OS.mac?

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "48097805d906d0c6febd72e06e2ba4c7de3fb98408c98538b98a16bf1e7bc066" => :catalina
    sha256 "7aad5ff734cec8f3c7f71540ee3d16f1423cc9526893d8e60d624f6d22f7dcbc" => :mojave
    sha256 "c3e6bfd3be85c039d1ea40706ce9921a21a2856e2b709dae38c2efb0a3996c37" => :high_sierra
    sha256 "237b9a980bef4463dc1f88c97093312292049f3e6184986179b7e2411337a8e6" => :sierra
    sha256 "4796f47dbb0dc9752af84742ddae73e8a0491fd0be16a0f2c4af1f36a2aba8a3" => :x86_64_linux
  end

  depends_on "cmake" => :build

  conflicts_with "libtcod", "minizip2",
    :because => "libtcod, libzip and minizip2 install a `zip.h` header"

  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
    depends_on "openssl@1.1"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    zip = OS.mac? ? "/usr/bin/zip" : which("zip")
    if zip.nil?
      opoo "Not testing unzip, because it requires zip, which is unavailable."
      return
    end

    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match /\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1)
  end
end
