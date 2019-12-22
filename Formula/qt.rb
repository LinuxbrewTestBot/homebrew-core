# qt: Build a bottle for Linux
# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/5.14/5.14.0/single/qt-everywhere-src-5.14.0.tar.xz"
  mirror "https://mirrors.dotsrc.org/qtproject/archive/qt/5.14/5.14.0/single/qt-everywhere-src-5.14.0.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/qt/archive/qt/5.14/5.1.0/single/qt-everywhere-src-5.14.0.tar.xz"
  sha256 "be9a77cd4e1f9d70b58621d0753be19ea498e6b0da0398753e5038426f76a8ba"

  head "https://code.qt.io/qt/qt5.git", :branch => "dev", :shallow => false

  bottle do
    cellar :any
    sha256 "80b6628ab4cb791447965aead90df06f6d293a643cfc5df625f6fab16c27170b" => :catalina
    sha256 "5820621ff53e91676c4a14b59a2bcc34cf880e75bfbe95bee11510ec3251eb7c" => :mojave
    sha256 "d3e8dc52ca3ff4f15fcbff62195c99f15f686141bf0bf1fb6926c007611d5e2a" => :high_sierra
    sha256 "65eef615d4e87e6917fae6a70ee094e537ecab3bc1f937c42a7fda1e043aa1e2" => :x86_64_linux
  end

  keg_only "Qt 5 has CMake issues when linked"

  depends_on "pkg-config" => :build
  depends_on :xcode => :build if OS.mac?
  depends_on :macos => :sierra if OS.mac?

  unless OS.mac?
    depends_on "fontconfig"
    depends_on "glib"
    depends_on "icu4c"
    depends_on "libproxy"
    depends_on "pulseaudio"
    depends_on "python@2"
    depends_on "sqlite"
    depends_on "systemd"
    depends_on "libxkbcommon"
    depends_on "linuxbrew/xorg/mesa"
    depends_on "linuxbrew/xorg/xcb-util-image"
    depends_on "linuxbrew/xorg/xcb-util-keysyms"
    depends_on "linuxbrew/xorg/xcb-util-renderutil"
    depends_on "linuxbrew/xorg/xcb-util"
    depends_on "linuxbrew/xorg/xcb-util-wm"
    depends_on "linuxbrew/xorg/xorg"
  end

  def install
    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -qt-libpng
      -qt-libjpeg
      -qt-freetype
      -qt-pcre
      -nomake examples
      -nomake tests
      -pkg-config
      -dbus-runtime
      -proprietary-codecs
    ]

    if OS.mac?
      args << "-no-rpath"
      args << "-system-zlib"
    elsif OS.linux?
      args << "-system-xcb"
      args << "-R#{lib}"
      # https://bugreports.qt.io/projects/QTBUG/issues/QTBUG-71564
      args << "-no-avx2"
      args << "-no-avx512"
      args << "-qt-zlib"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    # (Note: This move breaks invocation of Assistant via the Help menu
    # of both Designer and Linguist as that relies on Assistant being in `bin`.)
    libexec.mkpath
    Pathname.glob("#{bin}/*.app") { |app| mv app, libexec }
  end

  def caveats; <<~EOS
    We agreed to the Qt open source license for you.
    If this is unacceptable you should uninstall.
  EOS
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    system bin/"qmake", testpath/"hello.pro"
    system "make"
    assert_predicate testpath/"hello", :exist?
    assert_predicate testpath/"main.o", :exist?
    system "./hello"
  end
end
