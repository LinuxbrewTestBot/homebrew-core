class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.45.tgz"
  mirror "ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.45.tgz"
  sha256 "cdd6cffdebcd95161a73305ec13fc7a78e9707b46ca9f84fb897cd5626df3824"

  bottle do
    sha256 "809a58277010241b76cb9474b303d55540ae71c59ef401ece495f6b5ab57949c" => :sierra
    sha256 "645727db7cc901fa3493c66c06e55ecce778846961874deff6b1a4687aa04b35" => :el_capitan
    sha256 "ea5d0a84b570b85c6711a5c99dd12f2ba6811c7b3515ddd1b1d1761490a8fa81" => :yosemite
    sha256 "8e7e60c9bdea8dd7a6949d91566d2e8dd5254cd9e72d867d98bb1919bb730329" => :x86_64_linux # glibc 2.19
  end

  keg_only :provided_by_osx

  option "with-sssvlv", "Enable server side sorting and virtual list view"

  depends_on "berkeley-db@4" => :optional
  depends_on "openssl"
  unless OS.mac?
    depends_on "groff" => :build
    depends_on "util-linux" # for libuuid.so.1
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
      --enable-pic
    ]

    args << "--enable-bdb=no" << "--enable-hdb=no" if build.without? "berkeley-db@4"
    args << "--enable-sssvlv=yes" if build.with? "sssvlv"

    system "./configure", *args
    system "make", "install"
    (var+"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
