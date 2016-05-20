# scrollkeeper: Build a bottle for Linuxbrew
class Scrollkeeper < Formula
  desc "Transitional package for scrollkeeper"
  homepage "http://scrollkeeper.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/scrollkeeper/scrollkeeper/0.3.14/scrollkeeper-0.3.14.tar.gz"
  sha256 "4a0bd3c3a2c5eca6caf2133a504036665485d3d729a16fc60e013e1b58e7ddad"
  revision 1

  bottle do
    sha256 "fe0171c12bd61b59032a0914fd2279ca91132a714993d2dddd0f2641d8cb8142" => :el_capitan
    sha256 "ca1090d4daf705fc9bddc18b303ed1bf511ebd1173bcb48b17f5e47daab74351" => :yosemite
    sha256 "7e302cb0c50b34bf47cceefa2c79a8b565b06e7d850ea07f10992598c2058773" => :mavericks
    sha256 "e636c7888f5d3d005fa189127531f1e03901b49f172ccdebc3d2250343fe57f7" => :x86_64_linux
  end

  depends_on "gettext"
  depends_on "docbook"

  conflicts_with "rarian",
    :because => "scrollkeeper and rarian install the same binaries."

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make", "install"
  end
end
