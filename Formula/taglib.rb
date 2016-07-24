# taglib: Build a bottle for Linuxbrew
class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.github.io/"
  url "https://taglib.github.io/releases/taglib-1.11.tar.gz"
  sha256 "ed4cabb3d970ff9a30b2620071c2b054c4347f44fc63546dbe06f97980ece288"
  head "https://github.com/taglib/taglib.git"

  bottle do
    cellar :any
    sha256 "bef19bbb47be6a4068d9ccbb39fc3dd41796843b517437047570d77eb42f1ae6" => :x86_64_linux
  end

  option :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11 if build.cxx11?
    args = std_cmake_args + %w[
      -DWITH_MP4=ON
      -DWITH_ASF=ON
      -DBUILD_SHARED_LIBS=ON
    ]
    system "cmake", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taglib-config --version")
  end
end
