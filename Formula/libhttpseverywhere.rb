class Libhttpseverywhere < Formula
  desc "Bring HTTPSEverywhere to desktop apps"
  homepage "https://github.com/gnome/libhttpseverywhere"
  url "https://download.gnome.org/sources/libhttpseverywhere/0.8/libhttpseverywhere-0.8.3.tar.xz"
  sha256 "1c006f5633842a2b131c1cf644ab929556fc27968a60da55c00955bd4934b6ca"
  revision OS.mac? ? 2 : 3

  bottle do
    sha256 "332c2aad0bcc26b7e29c8fb77c4b4a3dc842d4e769aa323b4a39e298106e2516" => :mojave
    sha256 "2ce35886b26f24cf347feb2a603f75c26ed5a3ab81853e5e42a7494dbe0993b8" => :high_sierra
    sha256 "6b532d6d32e37b39e3ceeacb2914d23a8ef1b59347203a7c499cb39fb320a8ea" => :sierra
    sha256 "c6dc35ab2114924942f08fd412b4b5e0ea34751c6d72e3642a2b26614b8dc3b3" => :el_capitan
    sha256 "c76775f597612d801f97163d3dcd4ceae0cd063bfeaac97b51beec079f613af3" => :x86_64_linux
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libgee"
  depends_on "libsoup"

  # see https://gitlab.gnome.org/GNOME/libhttpseverywhere/issues/1
  # remove when next version is released
  patch do
    url "https://gitlab.gnome.org/GNOME/libhttpseverywhere/commit/6da08ef1ade9ea267cecf14dd5cb2c3e6e5e50cb.diff"
    sha256 "e5499c290c5b48b243f67763a2c710acc5bd52b90541eb8da3f8b24b516f7430"
  end

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end

    if OS.mac?
      dir = [Pathname.new("#{lib}64"), lib/"x86_64-linux-gnu"].find(&:directory?)
      unless dir.nil?
        mkdir_p lib
        system "/bin/mv", *Dir[dir/"*"], lib
        rmdir dir
        inreplace Dir[lib/"pkgconfig/*.pc"], %r{lib64|lib/x86_64-linux-gnu}, "lib"
      end
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <httpseverywhere.h>

      int main(int argc, char *argv[]) {
        GType type = https_everywhere_context_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    libarchive = Formula["libarchive"]
    libgee = Formula["libgee"]
    libsoup = Formula["libsoup"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/httpseverywhere-0.8
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libarchive.opt_include}
      -I#{libgee.opt_include}/gee-0.8
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{libarchive.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{lib}
      -larchive
      -lgee-0.8
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lhttpseverywhere-0.8
      -ljson-glib-1.0
      -lsoup-2.4
      -lxml2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
