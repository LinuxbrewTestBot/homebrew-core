# fig2dev: Build a bottle for Linuxbrew
class Fig2dev < Formula
  desc "Translates figures generated by xfig to other formats"
  homepage "https://mcj.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mcj/fig2dev-3.2.7.tar.xz"
  sha256 "de45819752f657ab7ebffe4a02fc99038d124a8f36be30550b21ef4fa03aa3a5"

  bottle do
    sha256 "748ce2ceaed220fcc73152d8190f717d29ee51e38a0005702cf19e7135bae4c9" => :high_sierra
    sha256 "dedc84ecc68dd473ca65c6fda6fd205e667c2bb8859f932e934329e57d4e2919" => :sierra
    sha256 "bd59320179ba9ca66a6d287a874720169ca44b7d4f7be997a6891f62146993d5" => :el_capitan
    sha256 "d8444c990bddfa075016a2dd4ee36d7003e0703ee661dd0166aa7caf186066f1" => :x86_64_linux
  end

  depends_on "ghostscript"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on :x11 => :optional
  depends_on "linuxbrew/xorg/xorg" if build.with?("x11") && !OS.mac?

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-transfig
    ]

    if build.with? "x11"
      args << "--with-xpm" << "--with-x"
    else
      args << "--without-xpm" << "--without-x"
    end

    system "./configure", *args
    system "make", "install"

    # Install a fig file for testing
    pkgshare.install "fig2dev/tests/data/patterns.fig"
  end

  test do
    system "#{bin}/fig2dev", "-L", "png", "#{pkgshare}/patterns.fig", "patterns.png"
    assert_predicate testpath/"patterns.png", :exist?, "Failed to create PNG"
  end
end
