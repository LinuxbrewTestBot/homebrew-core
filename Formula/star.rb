# star: Build a bottle for Linuxbrew
class Star < Formula
  desc "Standard tap archiver"
  homepage "http://cdrecord.org/private/star.html"
  url "https://downloads.sourceforge.net/project/s-tar/star-1.5.3.tar.bz2"
  sha256 "070342833ea83104169bf956aa880bcd088e7af7f5b1f8e3d29853b49b1a4f5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "64288e33524b1d1afcc5ae7e6ff5dc1488f1793eba9452e54279054d55e93db3" => :el_capitan
    sha256 "e3b77b33bc2c8ec917ddf41a29d937de1492253c7d039f5747e44e2361cfadd4" => :yosemite
    sha256 "410f5637ccdf115373b5a08c5037cdb8c66cb113719ead191070d087eae43285" => :mavericks
    sha256 "4ca6fd2d63832acd4f4f97ffff5bceeb9d462e9a3733a803a0168ba994e2aff3" => :x86_64_linux
  end

  depends_on "smake" => :build

  def install
    ENV.deparallelize # smake does not like -j

    system "smake", "GMAKE_NOWARN=true", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"

    # Remove symlinks that override built-in utilities
    (bin+"gnutar").unlink
    (bin+"tar").unlink
    (man1+"gnutar.1").unlink

    # Remove useless files
    lib.rmtree
    include.rmtree

    # Remove conflicting files
    %w[makefiles makerules].each { |f| (man5/"#{f}.5").unlink }
  end
end
