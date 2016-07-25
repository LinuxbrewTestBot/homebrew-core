# libidn: Build a bottle for Linuxbrew
class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftpmirror.gnu.org/libidn/libidn-1.33.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz"
  sha256 "44a7aab635bb721ceef6beecc4d49dfd19478325e1b47f3196f7d2acc4930e19"

  bottle do
    cellar :any
    sha256 "c091b6c0064dbf882ebd633af0041d767131757b6d00b255078c492f447099f1" => :x86_64_linux
  end

  option :universal

  depends_on "pkg-config" => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
