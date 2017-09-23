# aide: Build a bottle for Linuxbrew
class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/aide/aide/0.16/aide-0.16.tar.gz"
  sha256 "a81c53a131c4fd130b169b3a26ac35386a2f6e1e014f12807524cc273ed97345"

  bottle do
    rebuild 1
    sha256 "71d151f2f389cbbc5884eff30261d0691d020c0983411962c1ba42927d0ae052" => :sierra
    sha256 "2860850684659f15f8d5dc01127a7a9f2bfc21f773d99c4a8897585b4542723d" => :el_capitan
    sha256 "513e82f736d1e0c87795f5c6ca4d981d60bd64664f9b0cc5b20b0555e79a4071" => :x86_64_linux
  end

  head do
    url "https://git.code.sf.net/p/aide/code.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre"
  depends_on "curl" unless OS.mac?
  depends_on "bison" => :build unless OS.mac?
  depends_on "flex" => :build unless OS.mac?

  def install
    system "sh", "./autogen.sh" if build.head?

    system "./configure", "--disable-lfs",
                          "--disable-static",
                          "--with-curl#{OS.mac? ? "" : "=" + Formula["curl"].prefix}",
                          "--with-zlib",
                          "--sysconfdir=#{etc}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"aide.conf").write <<-EOS.undent
      database = file:/var/lib/aide/aide.db
      database_out = file:/var/lib/aide/aide.db.new
      database_new = file:/var/lib/aide/aide.db.new
      gzip_dbout = yes
      summarize_changes = yes
      grouped = yes
      verbose = 7
      database_attrs = sha256
      /etc p+i+u+g+sha256
    EOS
    system "#{bin}/aide", "--config-check", "-c", "aide.conf"
  end
end
