# ghc: Build a bottle for Linuxbrew
require "language/haskell"

class Ghc < Formula
  include Language::Haskell::Cabal

  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/8.6.4/ghc-8.6.4-src.tar.xz"
  sha256 "5b5d07e4463203a433c3ed3df461ba6cce11b6d2b9b264db31f3429075d0303a"

  bottle do
    sha256 "4a2c5a01f9e3ef499a30b25942e4d52ee86e2cb902b33dc11c1065948b9c4e50" => :mojave
    sha256 "72e530954801084477803d9f37265f4c067ab23ddae13826ac357acf954bb725" => :high_sierra
    sha256 "b115dacf7a6fee79a2c929d9406258e975eb6348e1471b877fe3122c80e6b4a5" => :sierra
  end

  head do
    url "https://git.haskell.org/ghc.git", :branch => "ghc-8.6"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "cabal" do
      url "https://hackage.haskell.org/package/cabal-install-2.4.0.0/cabal-install-2.4.0.0.tar.gz"
      sha256 "1329e9564b736b0cfba76d396204d95569f080e7c54fe355b6d9618e3aa0bef6"
    end
  end

  depends_on "python" => :build
  depends_on "sphinx-doc" => :build

  unless OS.mac?
    depends_on "m4" => :build
    depends_on "ncurses"

    # This dependency is needed for the bootstrap executables.
    depends_on "gmp" => :build
  end

  resource "gmp" do
    url "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz"
    mirror "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
    mirror "https://ftpmirror.gnu.org/gmp/gmp-6.1.2.tar.xz"
    sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"
  end

  # https://www.haskell.org/ghc/download_ghc_8_0_1#macosx_x86_64
  # "This is a distribution for Mac OS X, 10.7 or later."
  resource "binary" do
    if OS.linux?
      url "https://downloads.haskell.org/~ghc/8.4.4/ghc-8.4.4-x86_64-deb8-linux.tar.xz"
      sha256 "4c2a8857f76b7f3e34ecba0b51015d5cb8b767fe5377a7ec477abde10705ab1a"
    else
      url "https://downloads.haskell.org/~ghc/8.4.4/ghc-8.4.4-x86_64-apple-darwin.tar.xz"
      sha256 "28dc89ebd231335337c656f4c5ead2ae2a1acc166aafe74a14f084393c5ef03a"
    end
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j1" if ENV["CIRCLECI"]

    ENV["CC"] = ENV.cc
    ENV["LD"] = "ld"

    # Build a static gmp rather than in-tree gmp, otherwise all ghc-compiled
    # executables link to Homebrew's GMP.
    gmp = libexec/"integer-gmp"

    # GMP *does not* use PIC by default without shared libs so --with-pic
    # is mandatory or else you'll get "illegal text relocs" errors.
    resource("gmp").stage do
      if OS.mac?
        args = "--build=#{Hardware.oldest_cpu}-apple-darwin#{`uname -r`.to_i}"
      else
        args = "--build=core2-linux-gnu"
      end
      system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared",
                            *args
      system "make"
      system "make", "check"
      system "make", "install"
    end

    args = ["--with-gmp-includes=#{gmp}/include",
            "--with-gmp-libraries=#{gmp}/lib"]

    unless OS.mac?
      # Fix error while loading shared libraries: libgmp.so.10
      ln_s Formula["gmp"].lib/"libgmp.so", gmp/"lib/libgmp.so.10"
      ENV.prepend_path "LD_LIBRARY_PATH", gmp/"lib"
      # Fix /usr/bin/ld: cannot find -lgmp
      ENV.prepend_path "LIBRARY_PATH", gmp/"lib"
      # Fix ghc-stage2: error while loading shared libraries: libncursesw.so.5
      ln_s Formula["ncurses"].lib/"libncursesw.so", gmp/"lib/libncursesw.so.5"
      # Fix ghc-stage2: error while loading shared libraries: libtinfo.so.5
      ln_s Formula["ncurses"].lib/"libtinfo.so", gmp/"lib/libtinfo.so.5"
      # Fix ghc-pkg: error while loading shared libraries: libncursesw.so.6
      ENV.prepend_path "LD_LIBRARY_PATH", Formula["ncurses"].lib
    end

    # As of Xcode 7.3 (and the corresponding CLT) `nm` is a symlink to `llvm-nm`
    # and the old `nm` is renamed `nm-classic`. Building with the new `nm`, a
    # segfault occurs with the following error:
    #   make[1]: * [compiler/stage2/dll-split.stamp] Segmentation fault: 11
    # Upstream is aware of the issue and is recommending the use of nm-classic
    # until Apple restores POSIX compliance:
    # https://ghc.haskell.org/trac/ghc/ticket/11744
    # https://ghc.haskell.org/trac/ghc/ticket/11823
    # https://mail.haskell.org/pipermail/ghc-devs/2016-April/011862.html
    # LLVM itself has already fixed the bug: llvm-mirror/llvm@ae7cf585
    # rdar://25311883 and rdar://25299678
    if DevelopmentTools.clang_build_version >= 703 && DevelopmentTools.clang_build_version < 800
      args << "--with-nm=#{`xcrun --find nm-classic`.chomp}"
    end

    resource("binary").stage do
      # Change the dynamic linker and RPATH of the binary executables.
      if OS.linux? && Formula["glibc"].installed?
        keg = Keg.new(prefix)
        ["ghc/stage2/build/tmp/ghc-stage2"].concat(Dir["libraries/*/dist-install/build/*.so",
            "rts/dist/build/*.so*", "utils/*/dist*/build/tmp/*"]).each do |s|
          file = Pathname.new(s)
          keg.change_rpath(file, Keg::PREFIX_PLACEHOLDER, HOMEBREW_PREFIX.to_s) if file.dynamic_elf?
        end
      end

      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    if build.head?
      resource("cabal").stage do
        system "sh", "bootstrap.sh", "--sandbox"
        (buildpath/"bootstrap-tools/bin").install ".cabal-sandbox/bin/cabal"
      end

      ENV.prepend_path "PATH", buildpath/"bootstrap-tools/bin"

      cabal_sandbox do
        cabal_install "--only-dependencies", "happy", "alex"
        cabal_install "--prefix=#{buildpath}/bootstrap-tools", "happy", "alex"
      end

      system "./boot"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    ENV.deparallelize { system "make", "install" }
    Dir.glob(lib/"*/package.conf.d/package.cache") { |f| rm f }
  end

  def post_install
    system "#{bin}/ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    system "#{bin}/runghc", testpath/"hello.hs"
    system "#{bin}/ghc", "-o", "hello", "hello.hs"
    system "./hello"
  end
end
