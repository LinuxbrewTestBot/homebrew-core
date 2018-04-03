class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://code.pinguin.lu/diffusion/XMOUNT/xmount.git",
      :tag => "v0.7.6",
      :revision => "a417af7382c3e18fb8bd1341cc3307b09eefd578"

  bottle do
    sha256 "325b5e92c85b322def3c9bc708f82a9b89c58d3e57600dea85568dd9fe41ed7c" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "openssl"
  if OS.mac?
    depends_on :osxfuse
  else
    depends_on "libfuse"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl"].opt_lib/"pkgconfig"

    Dir.chdir "trunk" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"xmount", "--version"
  end
end
