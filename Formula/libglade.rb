# libglade: Build a bottle for Linuxbrew
class Libglade < Formula
  desc "RAD tool to help build GTK+ interfaces"
  homepage "https://glade.gnome.org"
  url "https://download.gnome.org/sources/libglade/2.6/libglade-2.6.4.tar.gz"
  sha256 "c41d189b68457976069073e48d6c14c183075d8b1d8077cb6dfb8b7c5097add3"
  revision 4

  bottle do
    sha256 "08b0055c32830a1af896041fbedfa9edc8bd6e2d70d0bf600b13495408978f8f" => :mojave
    sha256 "fbb11944fbd2e2ac64d0215e9887b20ed85309880ff78f2755a8ed3d9369c131" => :high_sierra
    sha256 "81103372f3f554685388e8f2f7547594a630bd99c238f8b37c252ec144eb4fea" => :sierra
    sha256 "52b22a0c5ffca4cd3f1e472d6a595a429aadb1418c0e3de0dd7be96561da6708" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "libxml2"

  def install
    ENV.append "LDFLAGS", "-lgmodule-2.0"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.c").write <<~EOS
      #include <glade/glade.h>

      int main(int argc, char *argv[]) {
        glade_init();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/libglade-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-#{OS.mac? ? "quartz" : "x11"}-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglade-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-#{OS.mac? ? "quartz" : "x11"}-2.0
      -lpango-1.0
      -lpangocairo-1.0
      -lxml2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
