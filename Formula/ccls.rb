class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20190314.tar.gz"
  sha256 "aaefa603a76325bb94e5222d144e19c432771346990c8b84165832bf37d15bb3"
  head "https://github.com/MaskRay/ccls.git"

  bottle do
    sha256 "d72512c7435985c15755c6a2dab68ce8032ca6e2372df722a3df38042b121323" => :mojave
    sha256 "5868f7f9e0b17c9ea43ef4658053c8b4dec82442f7736114c8c4019ba168386c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on :macos => :high_sierra # C++ 17 is required

  # C++17 is required
  depends_on "gcc@9" unless OS.mac?

  fails_with :gcc => "4"
  fails_with :gcc => "5"
  fails_with :gcc => "6"
  fails_with :gcc => "7" do
    version "7.1"
  end

  def install
    # https://github.com/Homebrew/brew/issues/6070
    unless OS.mac?
      ENV.remove %w[LDFLAGS LIBRARY_PATH HOMEBREW_LIBRARY_PATHS], "#{HOMEBREW_PREFIX}/lib"
    end

    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccls", "-index=#{testpath}"
  end
end
