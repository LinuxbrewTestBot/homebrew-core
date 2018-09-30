# openjdk: Build a bottle for Linuxbrew
class Openjdk < Formula
  desc "Java Development Kit"
  homepage "https://github.com/ojdkbuild/"
  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    prefix "/home/linuxbrew/.linuxbrew"
    cellar :any_skip_relocation
    sha256 "71c1102168426cf6beaae3f7f33985fc4e3d070ec12efa759b406d1de3a82e1f" => :x86_64_linux
  end

  # tag "linuxbrew"

  version "1.8.0-181"
  if OS.mac?
    url "http://java.com/"
  else
    url "https://github.com/ojdkbuild/contrib_jdk8u-ci/releases/download/jdk8u181-b13/jdk-8u181-ojdkbuild-linux-x64.zip"
    sha256 "fe5f5f8870e3195b0ee4c25c597b990ebbe8e667f3a345ff0afc49a8ff212dae"
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
