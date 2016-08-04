# libcroco: Build a bottle for Linuxbrew
class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.11.tar.xz"
  sha256 "132b528a948586b0dfa05d7e9e059901bca5a3be675b6071a90a90b81ae5a056"

  bottle do
    cellar :any
    sha256 "1f69e4e19622a87306c4d6b1ca6769b44f7cebb155b624a28a3bb4ecd98c7692" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib"

  # Fix error: No package 'libxml-2.0' found
  depends_on "libxml2" unless OS.mac?

  def install
    ENV.libxml2
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic"
    system "make", "install"
  end

  test do
    (testpath/"test.css").write ".brew-pr { color: green }"
    assert_equal ".brew-pr {\n  color : green\n}",
      shell_output("#{bin}/csslint-0.6 test.css").chomp
  end
end
