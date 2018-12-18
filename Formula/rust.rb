class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.31.0-src.tar.gz"
    sha256 "9ad54dc0baf1db5fc6a79d54e71c439c82aff85cd96778978456f2958211ef06"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          :tag      => "0.32.0",
          :revision => "339d9f9c8f400010df3282ae5582bf3a0f739004"
    end

    resource "racer" do
      # Racer should stay < 2.1 for now as 2.1 needs the nightly build of rust
      # See https://github.com/racer-rust/racer/tree/v2.1.2#installation
      url "https://github.com/racer-rust/racer/archive/2.0.14.tar.gz"
      sha256 "0442721c01ae4465843cb73b24f6caa0127c3308d72b944ad75736164756e522"
    end
  end

  bottle do
    cellar :any
    sha256 "89d160d79b56b0ae8189f0b3bf8f55cdd4d871ef9059cec9dda3f654b2f1b0ed" => :x86_64_linux
  end

  head do
    url "https://github.com/rust-lang/rust.git"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end

    resource "racer" do
      url "https://github.com/racer-rust/racer.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "libssh2"
  depends_on "openssl"
  depends_on "pkg-config"

  unless OS.mac?
    depends_on "binutils"
    depends_on "curl"
    depends_on "python@2"
    depends_on "zlib"
  end

  # According to the official readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc_4_2
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  resource "cargobootstrap" do
    if OS.mac?
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2018-10-25/cargo-0.31.0-x86_64-apple-darwin.tar.gz"
      sha256 "2b8fd336db9f98b778e4ed44186066952f02670cc1e49ade4e00fd55cef5e9f9"
    elsif OS.linux?
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2018-10-25/cargo-0.31.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fe03acbd158d680bbdd8009b242b5ee49a7deab129345ce9c539d7c523c22db0"
    end
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j1 -l2.0" if ENV["CIRCLECI"]

    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    # Fix build failure for cmake v0.1.24 "error: internal compiler error:
    # src/librustc/ty/subst.rs:127: impossible case reached" on 10.11, and for
    # libgit2-sys-0.6.12 "fatal error: 'os/availability.h' file not found
    # #include <os/availability.h>" on 10.11 and "SecTrust.h:170:67: error:
    # expected ';' after top level declarator" among other errors on 10.12
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    args = ["--prefix=#{prefix}"]
    args << "--disable-rpath" if build.head?
    if build.head?
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end
    system "./configure", *args
    system "make", *("-j1" if ENV["CIRCLECI"])
    system "make", "install"

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    resource("cargo").stage do
      ENV["RUSTC"] = bin/"rustc"
      system "cargo", "install", "--root", prefix, "--path", ".", *("--features" if OS.mac?), *("curl-sys/force-system-lib-on-osx" if OS.mac?)
    end

    resource("racer").stage do
      ENV.prepend_path "PATH", bin
      cargo_home = buildpath/"cargo_home"
      cargo_home.mkpath
      ENV["CARGO_HOME"] = cargo_home
      system "cargo", "install", "--root", libexec, "--path", "."
      (bin/"racer").write_env_script(libexec/"bin/racer", :RUST_SRC_PATH => pkgshare/"rust_src")
    end

    # Remove any binary files; as Homebrew will run ranlib on them and barf.
    rm_rf Dir["src/{llvm,llvm-emscripten,test,librustdoc,etc/snapshot.pyc}"]
    (pkgshare/"rust_src").install Dir["src/*"]

    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      chmod 0444, dylib
    end
  end

  test do
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end
