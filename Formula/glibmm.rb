# glibmm: Build a bottle for Linuxbrew
class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.60/glibmm-2.60.0.tar.xz"
  sha256 "a3a1b1c9805479a16c0018acd84b3bfff23a122aee9e3c5013bb81231aeef2bc"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    sha256 "a74600c4e04963030864c7775926bdda7792df1fdd778876d86c451ebacdd1c8" => :mojave
    sha256 "3b165387f62dd3aa1a2ddcbe9192e52589fb6b62440891f75d1e84f3217cd9dd" => :high_sierra
    sha256 "ece39cdc6ece8f6eafe70e8bf28876b727c129d24d9def5fc2ec513532650f9c" => :sierra
    sha256 "cfe433e5623056b079a907bb3479dbd4ea795580ba0b88ac90416304eb0b05e9" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++"

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j6" if ENV["CIRCLECI"]

    ENV.cxx11

    # see https://bugzilla.gnome.org/show_bug.cgi?id=781947
    # Note that desktopappinfo.h is not installed on Linux
    # if these changes are made.
    if OS.mac?
      inreplace "gio/giomm/Makefile.in" do |s|
        s.gsub! "OS_COCOA_TRUE", "OS_COCOA_TEMP"
        s.gsub! "OS_COCOA_FALSE", "OS_COCOA_TRUE"
        s.gsub! "OS_COCOA_TEMP", "OS_COCOA_FALSE"
      end
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lsigc-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
