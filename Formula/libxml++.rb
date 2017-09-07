class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io"
  url "https://download.gnome.org/sources/libxml++/2.40/libxml++-2.40.1.tar.xz"
  sha256 "4ad4abdd3258874f61c2e2a41d08e9930677976d303653cd1670d3e9f35463e9"
  revision 1 unless OS.mac?

  bottle do
    cellar :any
    sha256 "bb44b6bae21b4c6a0b2edfd675582a570e4ed63b71e6e08252a0dcd57b65834c" => :sierra
    sha256 "9bcaa205d33dbb8d44851e5f6c41ab95b322125cfd56215c55ce3abd0ac0b00e" => :el_capitan
    sha256 "53f18b1f5fe05dc545a8629292a498615ffd0c546c9fab98e5152be284081cbe" => :yosemite
    sha256 "8d120ff026529306553a82ca53c73747ee106b96ceb904d7cca54b807b32c4ff" => :mavericks
    sha256 "d7a3d87919a7bc34ae043aa825732f09a48c8bf2fbccc3e4e66fe66a30a1dcb1" => :x86_64_linux # glibc 2.19
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "http://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/libxml++-2.6
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/libxml++-2.6/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lsigc-2.0
      -lxml++-2.6
      -lxml2
    ]
    args << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
