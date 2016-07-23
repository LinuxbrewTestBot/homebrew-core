# chicken: Build a bottle for Linuxbrew
class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/4.11.0/chicken-4.11.0.tar.gz"
  sha256 "e3dc2b8f95b6a3cd59c85b5bb6bdb2bd9cefc45b5d536a20cad74e3c63f4ad89"
  head "https://code.call-cc.org/git/chicken-core.git"

  bottle do
    sha256 "2d1ab79d8f7a365f59ac6c47480475ba1c591192704230681098fc2140d2d3f3" => :x86_64_linux
  end

  def install
    ENV.deparallelize

    args = %W[
      PLATFORM=#{OS.mac? ? "macosx" : OS::NAME}
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
    ]
    args << "POSTINSTALL_PROGRAM=install_name_tool" if OS.mac?

    # Sometimes chicken detects a 32-bit environment by mistake, causing errors,
    # see https://github.com/Homebrew/homebrew/issues/45648
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
  end
end
