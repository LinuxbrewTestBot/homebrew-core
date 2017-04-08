class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.0.0/glew-2.0.0.tgz"
  sha256 "c572c30a4e64689c342ba1624130ac98936d7af90c3103f9ce12b8a0c5736764"
  head "https://github.com/nigels-com/glew.git"

  bottle do
    cellar :any
    sha256 "6d1af9d3f60da8c423fb1723c631abd784335b81cd8cda606fb0d30240dbae3a" => :sierra
    sha256 "200ab3d519d234bf9a34b223faa07c1ace46eeda197b9352e1b6dc0a67846b4b" => :el_capitan
    sha256 "6f2809e99ea25d6d33280921b5cd50e148800228450c34043d8ce11ac8f7e32c" => :yosemite
    sha256 "2b72bd7d59343ae64eaa87fd69f806759ac356a77300bb6b6a6ab40247384dc2" => :mavericks
    sha256 "b0850262c917bb6eb1d1aad9d26cab2aff10db52febbc09559bb504c171623e6" => :x86_64_linux
  end

  depends_on "linuxbrew/xorg/freeglut" unless OS.mac?

  def install
    inreplace "glew.pc.in", "Requires: @requireslib@", ""
    system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_PREFIX=#{prefix}", "GLEW_DEST=#{prefix}", "install.all"

    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <GL/glew.h>
      #include <GLUT/glut.h>

      int main(int argc, char** argv) {
        glutInit(&argc, argv);
        glutCreateWindow("GLEW Test");
        GLenum err = glewInit();
        if (GLEW_OK != err) {
          return 1;
        }
        return 0;
      }
    EOS
    flags = %W[
      -L#{lib}
      -lGLEW
    ]
    flags << "-framework" << "GLUT" if OS.mac?
    system ENV.cc, testpath/"test.c", "-o", "test", *flags
    system "./test"
  end
end

