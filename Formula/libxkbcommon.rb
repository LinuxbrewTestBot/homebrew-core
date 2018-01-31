class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.8.0.tar.xz"
  sha256 "e829265db04e0aebfb0591b6dc3377b64599558167846c3f5ee5c5e53641fe6d"
  revision 1 unless OS.mac?

  bottle do
    sha256 "7428e9599baa3dfca4a9c181c4d3a2ab934f37987aaad270c8a6fc3921da2c41" => :high_sierra
    sha256 "62e85d6d91d4f603d0ab2796904f07a754a782f6a0f23f424810a08b5deff347" => :sierra
    sha256 "32ee1c478aa17d7120d86370fd619de9b9ac39671d45d77a7a31ac550b0453d4" => :el_capitan
  end

  head do
    url "https://github.com/xkbcommon/libxkbcommon.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :x11 if OS.mac?
  depends_on "bison" => :build
  depends_on "pkg-config" => :build

  unless OS.mac?
    depends_on "linuxbrew/xorg/xkeyboardconfig"
    depends_on "linuxbrew/xorg/xorg"
    depends_on "linuxbrew/xorg/libxcb"
  end

  def install
    system "./autogen.sh" if build.head?
    if OS.mac?
      inreplace "configure" do |s|
        s.gsub! "-version-script $output_objdir/$libname.ver", ""
        s.gsub! "$wl-version-script", ""
      end
      inreplace %w[Makefile.in Makefile.am] do |s|
        s.gsub! "-Wl,--version-script=${srcdir}/xkbcommon.map", ""
        s.gsub! "-Wl,--version-script=${srcdir}/xkbcommon-x11.map", ""
      end
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <xkbcommon/xkbcommon.h>
      int main() {
        return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
          ? EXIT_FAILURE
          : EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system "./test"
  end
end
