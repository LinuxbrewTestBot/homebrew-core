# sip: Build a bottle for Linuxbrew
class Sip < Formula
  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://dl.bintray.com/homebrew/mirror/sip-4.19.8.tar.gz"
  mirror "https://downloads.sourceforge.net/project/pyqt/sip/sip-4.19.8/sip-4.19.8.tar.gz"
  sha256 "7eaf7a2ea7d4d38a56dd6d2506574464bddf7cf284c960801679942377c297bc"
  revision 7
  head "https://www.riverbankcomputing.com/hg/sip", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "38e39a92b598b92dd22ef602d489280854268833977bc1aab620593bc4ab53d4" => :mojave
    sha256 "b782756cf7e277ffad42e393dc2dde63d0a0575abe56e5f4c7c622b44ec7ae14" => :high_sierra
    sha256 "a1dcb1e526ec9d26101d961504ad1127920534cada88720bfdf1abce67d5573e" => :sierra
    sha256 "2260cd99b977edb34d92b2766c36b98ee1d765ee42e7e84db362bbd594f01633" => :x86_64_linux
  end

  depends_on "python"
  depends_on "python@2"

  def install
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
    ENV.delete("SDKROOT") # Avoid picking up /Application/Xcode.app paths

    if build.head?
      # Link the Mercurial repository into the download directory so
      # build.py can use it to figure out a version number.
      ln_s cached_download/".hg", ".hg"
      # build.py doesn't run with python3
      system "python", "build.py", "prepare"
    end

    ["python2", "python3"].each do |python|
      version = Language::Python.major_minor_version python
      system python, "configure.py",
                     *("--deployment-target=#{MacOS.version}" if OS.mac?),
                     "--destdir=#{lib}/python#{version}/site-packages",
                     "--bindir=#{bin}",
                     "--incdir=#{include}",
                     "--sipdir=#{HOMEBREW_PREFIX}/share/sip"
      system "make"
      system "make", "install"
      system "make", "clean"
    end
  end

  def post_install
    (HOMEBREW_PREFIX/"share/sip").mkpath
  end

  def caveats; <<~EOS
    The sip-dir for Python is #{HOMEBREW_PREFIX}/share/sip.
  EOS
  end

  test do
    (testpath/"test.h").write <<~EOS
      #pragma once
      class Test {
      public:
        Test();
        void test();
      };
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "test.h"
      #include <iostream>
      Test::Test() {}
      void Test::test()
      {
        std::cout << "Hello World!" << std::endl;
      }
    EOS
    (testpath/"test.sip").write <<~EOS
      %Module test
      class Test {
      %TypeHeaderCode
      #include "test.h"
      %End
      public:
        Test();
        void test();
      };
    EOS
    (testpath/"generate.py").write <<~EOS
      from sipconfig import SIPModuleMakefile, Configuration
      m = SIPModuleMakefile(Configuration(), "test.build")
      m.extra_libs = ["test"]
      m.extra_lib_dirs = ["."]
      m.generate()
    EOS
    (testpath/"run.py").write <<~EOS
      from test import Test
      t = Test()
      t.test()
    EOS
    if OS.mac?
      system ENV.cxx, "-shared", "-Wl,-install_name,#{testpath}/libtest.dylib",
                    "-o", "libtest.dylib", "test.cpp"
    else
      system ENV.cxx, "-fPIC", "-shared", "-Wl,-soname,#{testpath}/libtest.so",
                    "-o", "libtest.so", "test.cpp"
    end
    system bin/"sip", "-b", "test.build", "-c", ".", "test.sip"

    ["python2", "python3"].each do |python|
      version = Language::Python.major_minor_version python
      ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"
      system python, "generate.py"
      system "make", "-j1", "clean", "all"
      system python, "run.py"
    end
  end
end
