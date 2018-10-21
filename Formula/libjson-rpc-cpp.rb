# libjson-rpc-cpp: Build a bottle for Linuxbrew
class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.1.0.tar.gz"
  sha256 "8e699cad9f64e5db5c855ddfb6900dc55e673cc960cb9158818d652b74cb9183"
  revision 1
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "22dcbf652674c827fe849f3c189dfd7b848a40a9041b6ca51c1c40d206d96c19" => :mojave
    sha256 "694ea5c8b16a902866c1e655f1fd80bad87387f0f98601938b8879cd96a04395" => :high_sierra
    sha256 "f58cc4a7838987035b2721c2a09ec4aa1efee76eae10bb15fc4493f0c3a2e2f5" => :sierra
    sha256 "fdf9d7d6a8dbceabba7c7f8478df3e42e7242028d4258b22a159c4145d1c7921" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"
  depends_on "curl" unless OS.mac?

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
