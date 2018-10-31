class Binutils < Formula
  desc "FSF/GNU ld, ar, readelf, etc. for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.31.1.tar.gz"
  sha256 "e88f8d36bd0a75d3765a4ad088d819e35f8d7ac6288049780e2fefcad18dde88"
  revision 1

  bottle do
    cellar "{"any"=>:"manually added"}"
    sha256 "b4ed7c31d6738e2f084e801cb747f98cb63a4857ab5044c757ae361e3a68d32b" => :mojave
    sha256 "35253f02238a83fcfc243a79b1fb445d6bec93b2a602789e063896d03f0012f5" => :high_sierra
    sha256 "3fa0ed58f41b068c5c6e81e2ae99879f0f36f9588814f52be8806e09a3b7bca5" => :sierra
    sha256 "595876092114b5c4de50856d7f4ad16f4dbb1f4f92ed5f9cfdfd1478aea145ba" => :x86_64_linux
  end

  if OS.mac?
    keg_only :provided_by_macos,
             "because Apple provides the same tools and binutils is poorly supported on macOS"
  end

  unless OS.mac?
    option "without-gold", "Do not build the gold linker"

    depends_on "zlib" => :recommended unless OS.mac?
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          ("--with-sysroot=/" unless OS.mac?),
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          ("--enable-gold" if build.with? "gold"),
                          ("--enable-plugins" unless OS.mac?),
                          "--enable-targets=all"
    system "make"
    system "make", "install"
    bin.install_symlink "ld.gold" => "gold" if build.with? "gold"

    Dir["#{bin}/*"].each do |f|
      bin.install_symlink f => "g" + File.basename(f)
    end if OS.mac?

    # Reduce the size of the bottle.
    system "strip", *Dir[bin/"*", lib/"*.a"] unless OS.mac?
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
