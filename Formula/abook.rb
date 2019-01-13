# abook: Build a bottle for Linuxbrew
class Abook < Formula
  desc "Address book with mutt support"
  homepage "https://abook.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/abook/abook/0.5.6/abook-0.5.6.tar.gz"
  sha256 "0646f6311a94ad3341812a4de12a5a940a7a44d5cb6e9da5b0930aae9f44756e"
  revision 2
  head "https://git.code.sf.net/p/abook/git.git"

  bottle do
    sha256 "c1b909e5047e584971993e46ac28956479f1aca7edd28822df6de649fdb17bce" => :mojave
    sha256 "6dd4fd8e2f57239376ccbe02bc606829d0b976b18f94ae6e5204a7d546ae9a04" => :high_sierra
    sha256 "b078b7af5c5fca8c97e693b70a0700ab91d9bed44bdccbf037ed5eb800c32d7b" => :sierra
    sha256 "42fcad33e407e37d155fa9d795f2c518ef8e634b13be01e5f91994c6bce2eb78" => :x86_64_linux
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/abook", "--formats"
  end
end
