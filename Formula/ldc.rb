# ldc: Build a bottle for Linuxbrew
class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.17.0/ldc-0.17.0-src.tar.gz"
  sha256 "6c80086174ca87281413d7510641caf99dc630e6cf228a619d0d989bbf53bdd2"

  bottle do
    sha256 "f04ba535e659da235c9503ad67e5c669b148f7b313f96914bf6136913777298d" => :x86_64_linux
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.0.0-alpha1/ldc-1.0.0-alpha1-src.tar.gz"
    sha256 "b656437d0d7568c5ac4ef4366376184c06013e79f3dd5a512b18ca9f20df4b63"
    version "1.0.0-alpha1"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.0/ldc-0.17.0-src.tar.gz"
      sha256 "6c80086174ca87281413d7510641caf99dc630e6cf228a619d0d989bbf53bdd2"
    end
  end

  head do
    url "https://github.com/ldc-developers/ldc.git", :shallow => false

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc.git", :shallow => false, :branch => "ltsmaster"
    end
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "libconfig"

  def install
    # Fix the error:
    # CMakeFiles/LDCShared.dir/build.make:68: recipe for target 'dmd2/id.h' failed
    ENV.deparallelize if OS.linux?

    ENV.cxx11
    if build.stable?
      mkdir "build" do
        system "cmake", "..", "-DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc", *std_cmake_args
        system "make"
        system "make", "install"
      end
    else
      (buildpath/"ldc-lts").install resource("ldc-lts")
      cd "ldc-lts" do
        mkdir "build" do
          system "cmake", "..", *std_cmake_args
          system "make"
        end
      end
      mkdir "build" do
        system "cmake", "..", "-DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc", "-DD_COMPILER=../ldc-lts/build/bin/ldmd2", *std_cmake_args
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS

    system "#{bin}/ldc2", "test.d"
    system "./test"
    system "#{bin}/ldmd2", "test.d"
    system "./test"
  end
end
