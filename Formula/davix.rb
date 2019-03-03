# davix: Build a bottle for Linuxbrew
class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-it-sdc-id/davix.git",
      :tag      => "R_0_7_2",
      :revision => "b416d1604e3b38b48271e8bd080354b0262d8490"
  version "0.7.2"
  head "https://github.com/cern-it-sdc-id/davix.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    sha256 "094a9a44f16fa66f249085a5a9c851aa683a970f32959caa0ceb3d011cfa1624" => :mojave
    sha256 "a7de5508066a1c6de8e3cfe0c8e0f48ecb642b2fd721b175ad3941872ec6e2ee" => :high_sierra
    sha256 "7c5254106571e6ccc40ae21eb5139baf328081e576dcaf4d097d835237ffe81d" => :sierra
    sha256 "1e0abaf219df0027e05bf875155c7973c9ef957fe2acc4fd083fc757ebdafc2b" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@2" => :build
  depends_on "openssl"
  if OS.mac?
    depends_on "ossp-uuid"
  else
    depends_on "libxml2"
    depends_on "util-linux" # for libuuid
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j16" if ENV["CIRCLECI"]

    ENV.libcxx

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://www.google.com"
  end
end
