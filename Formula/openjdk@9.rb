# openjdk@9: Build a bottle for Linuxbrew
class OpenjdkAT9 < Formula
  desc "Java Development Kit"
  homepage "http://jdk.java.net/archive/"
  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    prefix "/home/linuxbrew/.linuxbrew"
    cellar :any_skip_relocation
    sha256 "16703337d5a1267958459faf34237b1ff1f2f2c7fcfd45024765acca90b66cd7" => :x86_64_linux
  end

  # tag "linuxbrew"

  version "9.0.4"
  if OS.mac?
    url "http://java.com/"
  else
    url "https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz"
    sha256 "39362fb9bfb341fcc802e55e8ea59f4664ca58fd821ce956d48e1aa4fb3d2dec"
  end

  depends_on :linux

  def install
    prefix.install Dir["*"]
    share.mkdir
    share.install prefix/"man"
  end

  test do
    (testpath/"Hello.java").write <<~EOS
      class Hello
      {
        public static void main(String[] args)
        {
          System.out.println("Hello Homebrew");
        }
      }
    EOS
    system bin/"javac", "Hello.java"
    assert_predicate testpath/"Hello.class", :exist?, "Failed to compile Java program!"
    assert_equal "Hello Homebrew\n", shell_output("#{bin}/java Hello")
  end
end
