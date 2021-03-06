class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.9.tar.gz"
  sha256 "a11e54469bb28173bba0dd1762b4648d4e79343927ba7f25067dfbf3db8e3b1d"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "8632b7b8dcee68fd57c7854bcfec806397a786132aee620d97d1759cd843b687" => :catalina
    sha256 "d15803038add303de62900f66ded75964212612582f005bed080d31687d49b71" => :mojave
    sha256 "2ef65ba6e5f79506b72c79194d5aa176eae2c77a9c11ce5d7dd991a7bed8d04a" => :high_sierra
    sha256 "606da3f37e61df3de2d5ecbe74b35bd866fa9a7e81fbf80bee559de998f35f0c" => :x86_64_linux
  end

  depends_on "readline"
  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"
  end

  test do
    # Test fails on CI: Input/output error @ io_fread - /dev/pts/0
    # Fixing it involves pty/ruby voodoo, which is not worth spending time on
    return if !OS.mac? && ENV["CI"]

    # Testing this curses app requires a pty
    require "pty"

    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
