class Arabica < Formula
  desc "XML toolkit written in C++"
  homepage "http://www.jezuk.co.uk/cgi-bin/view/arabica"
  url "https://github.com/jezhiggins/arabica/archive/2016-January.tar.gz"
  version "20160214"
  sha256 "ea6940773ae95ec02c6736c0ba688bdfb5c7691e7d2c8da1b331eca74949d73a"
  head "https://github.com/jezhiggins/arabica.git"

  bottle do
    cellar :any
    sha256 "04f7acb8f3458aed3aafeebf09f2f5465d5dfb9a05e15c49591bd0904907b793" => :x86_64_linux
  end

  option "without-test", "Skip compile-time make checks (Not Recommended)"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost" => :recommended
  depends_on "expat" unless OS.mac?

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end
