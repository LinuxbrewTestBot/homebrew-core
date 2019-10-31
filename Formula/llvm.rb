# llvm: Build a bottle for Linux
require "os/linux/glibc"

class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  revision 1

  stable do
    url "https://releases.llvm.org/9.0.0/llvm-9.0.0.src.tar.xz"
    sha256 "d6a0565cf21f22e9b4353b2eb92622e8365000a9e90a16b09b56f8157eabfe84"

    resource "clang" do
      url "https://releases.llvm.org/9.0.0/cfe-9.0.0.src.tar.xz"
      sha256 "7ba81eef7c22ca5da688fdf9d88c20934d2d6b40bfe150ffd338900890aa4610"

      unless OS.mac?
        patch do
          url "https://gist.githubusercontent.com/iMichka/9ac8e228679a85210e11e59d029217c1/raw/e50e47df860201589e6f43e9f8e9a4fc8d8a972b/clang9?full_index=1"
          sha256 "65cf0dd9fdce510e74648e5c230de3e253492b8f6793a89534becdb13e488d0c"
        end
      end
    end

    resource "clang-extra-tools" do
      url "https://releases.llvm.org/9.0.0/clang-tools-extra-9.0.0.src.tar.xz"
      sha256 "ea1c86ce352992d7b6f6649bc622f6a2707b9f8b7153e9f9181a35c76aa3ac10"
    end

    resource "compiler-rt" do
      url "https://releases.llvm.org/9.0.0/compiler-rt-9.0.0.src.tar.xz"
      sha256 "56e4cd96dd1d8c346b07b4d6b255f976570c6f2389697347a6c3dcb9e820d10e"
    end

    resource "libcxx" do
      url "https://releases.llvm.org/9.0.0/libcxx-9.0.0.src.tar.xz"
      sha256 "3c4162972b5d3204ba47ac384aa456855a17b5e97422723d4758251acf1ed28c"
    end

    resource "libcxxabi" do
      url "https://llvm.org/releases/6.0.1/libcxxabi-6.0.1.src.tar.xz"
      sha256 "209f2ec244a8945c891f722e9eda7c54a5a7048401abd62c62199f3064db385f"
    end

    resource "libunwind" do
      url "https://releases.llvm.org/9.0.0/libunwind-9.0.0.src.tar.xz"
      sha256 "976a8d09e1424fb843210eecec00a506b956e6c31adda3b0d199e945be0d0db2"
    end

    resource "lld" do
      url "https://releases.llvm.org/9.0.0/lld-9.0.0.src.tar.xz"
      sha256 "31c6748b235d09723fb73fea0c816ed5a3fab0f96b66f8fbc546a0fcc8688f91"
    end

    resource "lldb" do
      url "https://releases.llvm.org/9.0.0/lldb-9.0.0.src.tar.xz"
      sha256 "1e4c2f6a1f153f4b8afa2470d2e99dab493034c1ba8b7ffbbd7600de016d0794"
    end

    resource "openmp" do
      url "https://releases.llvm.org/9.0.0/openmp-9.0.0.src.tar.xz"
      sha256 "9979eb1133066376cc0be29d1682bc0b0e7fb541075b391061679111ae4d3b5b"
    end

    resource "polly" do
      url "https://releases.llvm.org/9.0.0/polly-9.0.0.src.tar.xz"
      sha256 "a4fa92283de725399323d07f18995911158c1c5838703f37862db815f513d433"
    end
  end

  bottle do
    cellar :any
    sha256 "a8e2475a1fc5a81f0da83a73d17fd54cc2a686f7b5d8e7ace9ea18885971415f" => :catalina
    sha256 "418d1e365a59f1ef41b36e444ea72e60f381ba02083659e0375838d81443b151" => :mojave
    sha256 "f9e02c2d5e6a5480e2f3f353d223acb170a9ba19fcd8d3ce38fbbc4e99a7d952" => :high_sierra
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { !OS.mac? || MacOS::CLT.installed? }
  end

  head do
    url "https://git.llvm.org/git/llvm.git"

    resource "clang" do
      url "https://git.llvm.org/git/clang.git"

      unless OS.mac?
        patch do
          url "https://gist.githubusercontent.com/iMichka/9ac8e228679a85210e11e59d029217c1/raw/e50e47df860201589e6f43e9f8e9a4fc8d8a972b/clang9?full_index=1"
          sha256 "65cf0dd9fdce510e74648e5c230de3e253492b8f6793a89534becdb13e488d0c"
        end
      end
    end

    resource "clang-extra-tools" do
      url "https://git.llvm.org/git/clang-tools-extra.git"
    end

    resource "compiler-rt" do
      url "https://git.llvm.org/git/compiler-rt.git"
    end

    resource "libcxx" do
      url "https://git.llvm.org/git/libcxx.git"
    end

    resource "libcxxabi" do
      url "http://llvm.org/git/libcxxabi.git"
    end

    resource "libunwind" do
      url "https://git.llvm.org/git/libunwind.git"
    end

    resource "lld" do
      url "https://git.llvm.org/git/lld.git"
    end

    resource "lldb" do
      url "https://git.llvm.org/git/lldb.git"
    end

    resource "openmp" do
      url "https://git.llvm.org/git/openmp.git"
    end

    resource "polly" do
      url "https://git.llvm.org/git/polly.git"
    end
  end

  keg_only :provided_by_macos

  # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on :xcode => :build if OS.mac?
  depends_on "libffi"
  depends_on "swig"

  unless OS.mac?
    depends_on "gcc" # needed for libstdc++
    depends_on "glibc" if Formula["glibc"].installed? || OS::Linux::Glibc.system_version < Formula["glibc"].version
    depends_on "binutils" # needed for gold and strip
    depends_on "libedit" # llvm requires <histedit.h>
    depends_on "libelf" # openmp requires <gelf.h>
    depends_on "ncurses"
    depends_on "libxml2"
    depends_on "zlib"
    depends_on "python@2"

    conflicts_with "clang-format", :because => "both install `clang-format` binaries"
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    (buildpath/"projects/openmp").install resource("openmp")
    (buildpath/"projects/libcxx").install resource("libcxx") if OS.mac?
    (buildpath/"projects/libunwind").install resource("libunwind")
    (buildpath/"tools/lld").install resource("lld")
    (buildpath/"tools/lldb").install resource("lldb")
    (buildpath/"tools/polly").install resource("polly")
    (buildpath/"projects/compiler-rt").install resource("compiler-rt")

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    unless OS.mac?
      # see https://llvm.org/docs/HowToCrossCompileBuiltinsOnArm.html#the-cmake-try-compile-stage-fails
      # Basically, the stage1 clang will try to locate a gcc toolchain and often
      # get the default from /usr/local, which might contains an old version of
      # gcc that can't build compiler-rt. This fixes the problem and, unlike
      # setting the main project's cmake option -DGCC_INSTALL_PREFIX, avoid
      # hardcoding the gcc path into the binary
      inreplace "projects/compiler-rt/CMakeLists.txt", /(cmake_minimum_required.*\n)/,
        "\\1add_compile_options(\"--gcc-toolchain=#{Formula["gcc"].opt_prefix}\")"
    end

    args = %W[
      -DLIBOMP_ARCH=x86_64
      -DLINK_POLLY_INTO_TOOLS=ON
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON
      -DLLVM_BUILD_LLVM_DYLIB=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DWITH_POLLY=ON
      -DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include
      -DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_DISABLE_PYTHON=1
      -DLIBOMP_INSTALL_ALIASES=OFF
    ]
    if OS.mac?
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
    else
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=OFF"
      args << "-DLLVM_ENABLE_LIBCXX=OFF"
      args << "-DCLANG_DEFAULT_CXX_STDLIB=libstdc++"
    end

    # Enable llvm gold plugin for LTO
    args << "-DLLVM_BINUTILS_INCDIR=#{Formula["binutils"].opt_include}" unless OS.mac?

    mkdir "build" do
      if MacOS.version >= :mojave
        sdk_path = MacOS::CLT.installed? ? "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" : MacOS.sdk_path
        args << "-DDEFAULT_SYSROOT=#{sdk_path}"
      end

      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if OS.mac?
    end

    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
    (share/"cmake").install "cmake/modules"
    inreplace "#{share}/clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
    bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
    man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"

    # install llvm python bindings
    (lib/"python2.7/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang"

    unless OS.mac?
      # Strip executables/libraries/object files to reduce their size
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end
  end

  def caveats; <<~EOS
    To use the bundled libc++ please add the following LDFLAGS:
      LDFLAGS="-L#{opt_lib} -Wl,-rpath,#{opt_lib}"
  EOS
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    (testpath/"omptest.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <omp.h>
      int main() {
          #pragma omp parallel num_threads(4)
          {
            printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
          }
          return EXIT_SUCCESS;
      }
    EOS

    clean_version = version.to_s[/(\d+\.?)+/]

    system "#{bin}/clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                           "-I#{lib}/clang/#{clean_version}/include",
                           "omptest.c", "-o", "omptest", *ENV["LDFLAGS"].split
    testresult = shell_output("./omptest")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello World!" << std::endl;
        return 0;
      }
    EOS

    unless OS.mac?
      system "#{bin}/clang++", "-v", "test.cpp", "-o", "test"
      assert_equal "Hello World!", shell_output("./test").chomp
    end

    # Testing Command Line Tools
    if OS.mac? && MacOS::CLT.installed?
      libclangclt = Dir["/Library/Developer/CommandLineTools/usr/lib/clang/#{MacOS::CLT.version.to_i}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I/Library/Developer/CommandLineTools/usr/include/c++/v1",
              "-I#{libclangclt}/include",
              "-I/usr/include", # need it because /Library/.../usr/include/c++/v1/iosfwd refers to <wchar.h>, which CLT installs to /usr/include
              "test.cpp", "-o", "testCLT++"
      # Testing default toolchain and SDK location.
      system "#{bin}/clang++", "-v",
             "-std=c++11", "test.cpp", "-o", "test++"
      assert_includes MachO::Tools.dylibs("test++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./test++").chomp
      system "#{bin}/clang", "-v", "test.c", "-o", "test"
      assert_equal "Hello World!", shell_output("./test").chomp

      toolchain_path = "/Library/Developer/CommandLineTools"
      sdk_path = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
      system "#{bin}/clang++", "-v",
             "-isysroot", sdk_path,
             "-isystem", "#{toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{toolchain_path}/usr/include",
             "-isystem", "#{sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testCLT++").chomp
      system "#{bin}/clang", "-v", "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if OS.mac? && MacOS::Xcode.installed?
      system "#{bin}/clang++", "-v",
             "-isysroot", MacOS.sdk_path,
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include",
             "-isystem", "#{MacOS.sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testXC++"
      assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testXC++").chomp
      system "#{bin}/clang", "-v",
             "-isysroot", MacOS.sdk_path,
             "test.c", "-o", "testXC"
      assert_equal "Hello World!", shell_output("./testXC").chomp
    end

    # link against installed libc++
    # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
    if OS.mac?
      system "#{bin}/clang++", "-v",
             "-isystem", "#{opt_include}/c++/v1",
             "-std=c++11", "-stdlib=libc++", "test.cpp", "-o", "testlibc++",
             "-L#{opt_lib}", "-Wl,-rpath,#{opt_lib}"
      assert_includes MachO::Tools.dylibs("testlibc++"), "#{opt_lib}/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testlibc++").chomp

      (testpath/"scanbuildtest.cpp").write <<~EOS
        #include <iostream>
        int main() {
          int *i = new int;
          *i = 1;
          delete i;
          std::cout << *i << std::endl;
          return 0;
        }
      EOS
      assert_includes shell_output("#{bin}/scan-build clang++ scanbuildtest.cpp 2>&1"),
        "warning: Use of memory after it is freed"

      (testpath/"clangformattest.c").write <<~EOS
        int    main() {
            printf("Hello world!"); }
      EOS
      assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}/clang-format -style=google clangformattest.c")
    end
  end
end
