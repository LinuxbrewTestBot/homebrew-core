class OpenjdkAT9 < Formula
  desc "Java Development Kit"
  homepage "http://jdk.java.net/archive/"
  # tag "linuxbrew"

  version "9.0.4"
  version_scheme 1
  if OS.mac?
    url "http://java.com/"
  else
	  url "https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz"
    sha256 "39362fb9bfb341fcc802e55e8ea59f4664ca58fd821ce956d48e1aa4fb3d2dec"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "28f3f2a65df223b4c95beece2125f9d8888c556250e269b8be9017458f8fc6c1" => :x86_64_linux
  end

  def install
    odie "Use 'brew cask install java' on Mac OS" if OS.mac?
    prefix.install Dir["*"]
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
