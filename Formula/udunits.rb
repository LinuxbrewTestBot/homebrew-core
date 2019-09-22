class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "https://github.com/Unidata/UDUNITS-2/archive/v2.2.27.6.tar.gz"
  sha256 "74fd7fb3764ce2821870fa93e66671b7069a0c971513bf1904c6b053a4a55ed1"

  bottle do
    sha256 "176548e1d698baf5187088bf16b273af3e3e585f5f765963c396187491ea5fe1" => :mojave
    sha256 "3c12f59317ded4bdc6f89c24a0eec9260a499371c9c92b2d5e34c1b1a9f50a2c" => :high_sierra
    sha256 "ad941124a4952ebc353f03601d3da5670155a1eb8271e290bc96b0a54ec87e9e" => :sierra
    sha256 "4243dd63fc3decf1f529e86fd19897a2e4311f9d91ebfc812ceeec13cab9149a" => :x86_64_linux
  end

  depends_on "cmake" => :build
  uses_from_macos "expat"

  unless OS.mac?
    depends_on "texinfo"

    patch :p1 do
      url "https://github.com/Unidata/UDUNITS-2/commit/0bb56200221ad960bc2da11fc0b4a70ec3c5d7c9.diff"
      sha256 "302fc33a7df84d8a60a21a0024d2676d5d16c08d3eb61d48e04d70f9499616f2"
    end
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
