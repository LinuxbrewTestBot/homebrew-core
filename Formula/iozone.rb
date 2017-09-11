class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_468.tar"
  sha256 "780801a4ce54503ea1060445497471b79bdb05db21338c77f96a5ac51ffac4ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "06d03be4d1ed3c2059f47f9b997233729cf6c10cc25e4562634762689675aca2" => :sierra
    sha256 "aa525afb22a1c4909ffa5e6d74474431f91ee6cb5997f8bba7e02884f294bd7b" => :el_capitan
    sha256 "88065f015367a06d67bff5ddd37733a29469c8b08a1039b692beb7a27a8e836e" => :x86_64_linux
  end

  def install
    cd "src/current" do
      system "make", OS.mac? ? "macosx" : "linux", "CC=#{ENV.cc}"
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
