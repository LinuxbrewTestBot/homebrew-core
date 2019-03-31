# freetds: Build a bottle for Linuxbrew
class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "http://www.freetds.org/"
  url "http://www.freetds.org/files/stable/freetds-1.1.3.tar.gz"
  sha256 "bd08d2b7e6b7819fec611f02ff5b48a53298d46f733385f12e83289c017f2d1c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    sha256 "66ce6291c83495f7372ae00559eccc8044c19d61642f5f02a375c22e63ac88d5" => :mojave
    sha256 "79172589792275fd0ae469364a01b8ffc617080687a6523f1401c210d122cb08" => :high_sierra
    sha256 "d1d7e4eb2fe06e76e8b257770477969b70d4bc3159bd1d08b8c759ca1affdfac" => :sierra
    sha256 "9e8f054f035cff860ca2b478489af47a98812c420143ca293971659d585f1f88" => :x86_64_linux
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "unixodbc"
  depends_on "readline" unless OS.mac?

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
