# gtk+: Build a bottle for Linxubrew
class Gtkx < Formula
  desc "GUI toolkit"
  homepage "http://gtk.org/"

  stable do
    url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.30.tar.xz"
    sha256 "0d15cec3b6d55c60eac205b1f3ba81a1ed4eadd9d0f8e7c508bc7065d0c4ca50"
  end

  bottle do
    sha256 "f026134bfec8e9ed9534ce709e43b975ae0da8107be688b82bd0861602637591" => :x86_64_linux
  end

  head do
    url "https://git.gnome.org/browse/gtk+.git", :branch => "gtk-2-24"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

  option :universal
  option "with-quartz-relocation", "Build with quartz relocation support"

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "jasper" => :optional
  depends_on "atk"
  depends_on "pango"
  depends_on "gobject-introspection"
  depends_on "hicolor-icon-theme"
  depends_on "cairo" unless OS.mac?

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  # Patch to allow Freeciv's gtk2 client to run.
  # See:
  # - https://bugzilla.gnome.org/show_bug.cgi?id=557780
  # - Homebrew/homebrew-games#278
  patch do
    url "https://bug557780.bugzilla-attachments.gnome.org/attachment.cgi?id=306776"
    sha256 "4d7a1fe8d55174dc7f0be0016814668098d38bbec233b05a6c46180e96a159fc"
  end

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--disable-glibtest",
            "--enable-introspection=yes",
            "--with-gdktarget=#{OS.mac? ? 'quartz' : 'x11'}",
            "--disable-visibility"]

    args << "--enable-quartz-relocation" if build.with?("quartz-relocation")

    # temporarily disable cups until linuxbrew/homebrew-core#495 is merged
    args << "--disable-cups" unless OS.mac?

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        GtkWidget *label = gtk_label_new("Hello World!");
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    backend = OS.mac? ? "quartz" : "x11"
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gtk-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/gtk-2.0/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-#{backend}-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-#{backend}-2.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
