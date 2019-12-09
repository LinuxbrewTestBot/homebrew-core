class OpenjdkAT11 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://hg.openjdk.java.net/jdk-updates/jdk11u/archive/jdk-11.0.5+10.tar.bz2"
  version "11.0.5+10"
  sha256 "5375ca18b2c9f301e8ae6f77192962a5ec560d808f3e899bb17719c82eae5407"

  bottle do
    cellar :any
    sha256 "e7c029f0e2802754a2367b6635cc79255e687fdcf8610e4fc3b8a9d8c5cd7de0" => :catalina
    sha256 "5458efd7a104c7969e17984f61f254402dce0f654c6f67172d71bcda284f5706" => :mojave
    sha256 "12f9a799d3087f88dd3ba060b00e92152e7556d7ee03004502a1e6dff2968bfa" => :high_sierra
    sha256 "56b74b9dd4ae248e533f16c03941e31425c8a0a9461b2f6bf82752897168dc2a" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "cups"
    depends_on "fontconfig"
    depends_on "unzip"
    depends_on "zip"
    depends_on "linuxbrew/xorg/libx11"
    depends_on "linuxbrew/xorg/libxext"
    depends_on "linuxbrew/xorg/libxrandr"
    depends_on "linuxbrew/xorg/libxrender"
    depends_on "linuxbrew/xorg/libxt"
    depends_on "linuxbrew/xorg/libxtst"
  end

  resource "boot-jdk" do
    if OS.mac?
      url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_osx-x64_bin.tar.gz"
      sha256 "77ea7675ee29b85aa7df138014790f91047bfdafbc997cb41a1030a0417356d7"
    else
      url "https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz"
      sha256 "f3b26abc9990a0b8929781310e14a339a7542adfd6596afb842fa0dd7e3848b2"
    end
  end

  def install
    boot_jdk_dir = Pathname.pwd/"boot-jdk"
    resource("boot-jdk").stage boot_jdk_dir
    boot_jdk = OS.mac? ? boot_jdk_dir/"Contents/Home" : boot_jdk_dir
    java_options = ENV.delete("_JAVA_OPTIONS")

    short_version, _, build = version.to_s.rpartition("+")

    chmod 0755, "configure"
    system "./configure", "--without-version-pre",
                          "--without-version-opt",
                          "--with-version-build=#{build}",
                          "--with-toolchain-path=/usr/bin",
                          ("--with-extra-ldflags=-headerpad_max_install_names" if OS.mac?),
                          "--with-boot-jdk=#{boot_jdk}",
                          "--with-boot-jdk-jvmargs=#{java_options}",
                          "--with-debug-level=release",
                          "--with-native-debug-symbols=none",
                          "--enable-dtrace=auto",
                          "--with-jvm-variants=server",
                          ("--with-x=#{HOMEBREW_PREFIX}" unless OS.mac?),
                          ("--with-cups=#{HOMEBREW_PREFIX}" unless OS.mac?),
                          ("--with-fontconfig=#{HOMEBREW_PREFIX}" unless OS.mac?)

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "images"

    if OS.mac?
      libexec.install "build/macosx-x86_64-server-release/images/jdk-bundle/jdk-#{short_version}.jdk" => "openjdk.jdk"
      bin.install_symlink Dir["#{libexec}/openjdk.jdk/Contents/Home/bin/*"]
    else
      libexec.install Dir["build/linux-x86_64-normal-server-release/images/jdk/*"]
      bin.install_symlink Dir["#{libexec}/bin/*"]
    end
  end

  def caveats
    <<~EOS
      For the system Java wrappers to find this JDK, symlink it with
        sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
    EOS
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
