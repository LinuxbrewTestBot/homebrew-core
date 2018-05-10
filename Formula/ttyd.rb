# ttyd: Build a bottle for Linuxbrew
class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.4.0.tar.gz"
  sha256 "757a9b5b5dd3de801d7db8fab6035d97ea144b02a51c78bdab28a8e07bcf05d6"
  revision 1
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "6320a24cf4ab8b66791af5c47314a0558920a79b95b3c48612a94ccc35e5bc27" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "json-c"
  depends_on "libwebsockets"
  depends_on "vim" unless OS.mac? # needed for xxd

  def install
    cmake_args = std_cmake_args + ["-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
