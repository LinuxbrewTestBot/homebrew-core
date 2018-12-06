# dialog: Build a bottle for Linuxbrew
class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20181107.tgz"
  sha256 "efeaca8027dda53a9f3cf6c7b5c1a77093825b7a9b85c23c0c6c96afc3506457"

  bottle do
    cellar :any_skip_relocation
    sha256 "c356e3a474ebf3d580ec4674d87aec9c88ba7137e0f6fefd8c73cbf99d327b76" => :mojave
    sha256 "cf169dff8e776ac85d3a662db2abd9fbd578affc994dcb866547ee06630b68f6" => :high_sierra
    sha256 "68b0c43919cde70242f56ba550b666c2a6f9e6baefca50615923efa262052d5b" => :sierra
    sha256 "8b4bbf34651db00003ac40107b4265c6069de37f573c5494e8b83efa32b7113b" => :x86_64_linux
  end

  depends_on "ncurses" unless OS.mac?

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
