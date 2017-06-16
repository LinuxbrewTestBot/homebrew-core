# libepoxy: Build a bottle for Linuxbrew
class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.4/libepoxy-1.4.3.tar.xz"
  sha256 "0b808a06c9685a62fca34b680abb8bc7fb2fda074478e329b063c1f872b826f6"

  bottle do
    cellar :any
    sha256 "a96a0e088b6f292422108da73868700ef1a332ebd170695a77e90be7a12a4f86" => :sierra
    sha256 "0ce6f61e0062f6869e47b95363b373502c62cf343ef26bedcf0c4a9819851c79" => :el_capitan
    sha256 "55b56dd68e17a27fa211426ea199084dbdca228a4fc63ddd0d1b3f79ea3c9a1a" => :yosemite
    sha256 "6076cc9f2497078db0f2f9d500b5646b6763ef8628d9b69647adf68f0d2cd603" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "linuxbrew/xorg/mesa" if OS.linux?

  def install
    # see https://github.com/anholt/libepoxy/pull/128
    inreplace "src/meson.build", "version=1", "version 1"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "test"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent

      #include <epoxy/gl.h>
      #ifdef OS_MAC
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #endif
      int main()
      {
          #ifdef OS_MAC
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);
          #endif

          glClear(GL_COLOR_BUFFER_BIT);
          #ifdef OS_MAC
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          #endif
          return 0;
      }
    EOS
    args = %w[-lepoxy -o test]
    args += %w[-framework OpenGL -DOS_MAC] if OS.mac?
    system ENV.cc, "test.c", *args
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
