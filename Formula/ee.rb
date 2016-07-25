# ee: Build a bottle for Linuxbrew
class Ee < Formula
  desc "Terminal (curses-based) text editor with pop-up menus"
  homepage "http://www.users.qwest.net/~hmahon/"
  url "http://www.users.qwest.net/~hmahon/sources/ee-1.4.6.src.tgz"
  sha256 "a85362dbc24c2bd0f675093fb593ba347b471749c0a0dbefdc75b6334a7b6e4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "35eda2a59749374c68232f331b9a4d9b3883e3c6599e32e7337dcd361041179b" => :x86_64_linux
  end

  def install
    system "make", "localmake"
    system "make", "all"

    # Install manually
    bin.install "ee"
    man1.install "ee.1"
  end

  test do
    ENV["TERM"] = "xterm"
    # escape + a + b is the exit sequence for `ee`
    pipe_output("#{bin}/ee", "\\033[ab", 0)
  end
end
