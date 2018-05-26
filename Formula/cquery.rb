class Cquery < Formula
  desc "C/C++ language server"
  homepage "https://github.com/cquery-project/cquery"
  # pull from git tag to get submodules
  url "https://github.com/cquery-project/cquery.git", :tag => "v20180302",
                                                      :revision => "f3e9e756e182b122bef8826a77047f6ccf5529b6"
  head "https://github.com/cquery-project/cquery.git"
  revision 1 unless OS.mac?

  unless OS.mac?
    depends_on "python@2" => :build
    depends_on "llvm"

    needs :cxx11
  end

  bottle do
    cellar :any
    sha256 "af561ae561200570f79e22725a1d13aee04827d40e036b3750babe36164ce5ef" => :x86_64_linux
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["JOBS"] = "8" if ENV["CIRCLECI"]

    system "./waf", "configure", "--prefix=#{prefix}", ("--llvm-config=#{Formula["llvm"].opt_bin/"llvm-config"}" unless OS.mac?)
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system bin/"cquery", "--test-unit"
  end
end
