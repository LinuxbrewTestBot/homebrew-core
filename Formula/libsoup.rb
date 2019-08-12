class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.66/libsoup-2.66.2.tar.xz"
  sha256 "bd2ea602eba642509672812f3c99b77cbec2f3de02ba1cc8cb7206bf7de0ae2a"
  revision OS.mac? ? 1 : 2

  bottle do
    sha256 "8336aa92e8a2638745181f159f848b264bec952ecb5571eb36a3dbe62da3a016" => :mojave
    sha256 "f157867c692050ca95d78b048c01a1f1ada8a8c53c3a65e83397de2a3ae92af8" => :high_sierra
    sha256 "e8dbd05c6f0eeb707192192c6e1c370678ee63db12963dc1329e61e62b302398" => :sierra
    sha256 "be44ad148ec154bb4ed4bd4aac08e166a931dc98d823647a60e62711d423b8dd" => :x86_64_linux
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"
  depends_on "vala"
  unless OS.mac?
    depends_on "libxml2"
    depends_on "krb5"
    depends_on "python@2" => :build
  end

  def install

    unless OS.mac?
      # set rpath for binaries
      inreplace "libsoup/meson.build", /(library.*?install\s*:\s*true)/m, "\\1, install_rpath: '#{ENV.determine_rpath_paths(self)}'"
    end

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    unless OS.mac?
      # move lib64 to lib and symlink lib64 -> lib
      lib64 = Pathname.new "#{lib}64"
      if lib64.directory?
        mkdir_p lib
        system "mv #{lib64}/* #{lib}/"
        rmdir lib64
        prefix.install_symlink "lib" => "lib64"
      end
    end
  end

  test do
    # if this test start failing, the problem might very well be in glib-networking instead of libsoup
    (testpath/"test.c").write <<~EOS
      #include <libsoup/soup.h>

      int main(int argc, char *argv[]) {
        SoupMessage *msg = soup_message_new("GET", "https://brew.sh");
        SoupSession *session = soup_session_new();
        soup_session_send_message(session, msg); // blocks
        g_assert_true(SOUP_STATUS_IS_SUCCESSFUL(msg->status_code));
        g_object_unref(msg);
        g_object_unref(session);
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libsoup-2.4
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lsoup-2.4
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
