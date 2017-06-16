class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.7.1.tar.xz"
  sha256 "ba59305d2e19e47c27ea065c2e0df96ebac6a3c6e97e28ae5620073b6084e68b"
  revision 1 unless OS.mac?

  bottle do
    sha256 "882d937c19ddafc75b287aec758ce56af495df0af46d401425085d88dcbbba29" => :x86_64_linux
  end

  head do
    url "https://github.com/xkbcommon/libxkbcommon.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  if OS.mac?
    depends_on :x11
    depends_on "bison" => :build
  end
  depends_on "pkg-config" => :build

  unless OS.mac?
    depends_on "linuxbrew/xorg/xkeyboardconfig"
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
    (testpath/"test.c").write <<-EOS.undent
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
