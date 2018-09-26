# libgsf: Build a bottle for Linuxbrew
class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.44.tar.xz"
  sha256 "68bede10037164764992970b4cb57cd6add6986a846d04657af9d5fac774ffde"

  bottle do
    rebuild 1
    sha256 "66701ea00c8da80e3650ba87b140765bae4b1cee013791dc14e7debbd4b7a342" => :mojave
    sha256 "5ba6de277d54dd9b9ad5731bb5c942e73f820a731182bc8cc02a0382c484c7c6" => :high_sierra
    sha256 "ca613e132ce34edeb475550ce1202da43a170cd9a64d81f7d8b71ab4142c9280" => :sierra
    sha256 "d520330d8b278d76a727b1e2502bbcd4c661023199948fc374d007101839a4e3" => :el_capitan
    sha256 "f4524ec2200bed54f2d6eb09d7c0fc14c305bd696157a7fd12f5226b38bf0d1f" => :x86_64_linux
  end

  head do
    url "https://github.com/GNOME/libgsf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libxml2" unless OS.mac?

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5" unless OS.mac?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<~EOS
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
