class Qwt < Formula
  desc "Qt Widgets for Technical Applications"
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.1.3/qwt-6.1.3.tar.bz2"
  sha256 "f3ecd34e72a9a2b08422fb6c8e909ca76f4ce5fa77acad7a2883b701f4309733"
  revision 5

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a0440f8bbfaa4a88a44ad02aac93cd1d96a45b59f0b4e3c6133c150dd877e100" => :mojave
    sha256 "fefafb68b60362fb7c2f268171cf111a7676044d2586698d786bc448263cd315" => :high_sierra
    sha256 "b333be61fb0188cdf98510566dd28ac51c677eba50c7257d7b5145d7619d7a44" => :sierra
    sha256 "f7aeec647433b1c74e51450250346cb860946c20ae28b9859ffc2e1043db51e2" => :x86_64_linux
  end

  depends_on "qt"

  # Update designer plugin linking back to qwt framework/lib after install
  # See: https://sourceforge.net/p/qwt/patches/45/
  patch :DATA

  def install
    inreplace "qwtconfig.pri" do |s|
      s.gsub! /^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{prefix}"

      # Install Qt plugin in `lib/qt/plugins/designer`, not `plugins/designer`.
      s.sub! %r{(= \$\$\{QWT_INSTALL_PREFIX\})/(plugins/designer)$},
             "\\1/lib/qt/\\2"
    end

    args = ["-config", "release"]
    if OS.mac?
      args.push "-spec"
      if ENV.compiler == :clang
        args.push "macx-clang"
      else
        args.push "macx-g++"
      end
    end

    system "qmake", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"plotcurve.pro").write <<~EOS
      QT       += core gui
      CONFIG   -= console
      CONFIG   += app_bundle
      CONFIG   += qwt c++11
      SOURCES  += test.cpp
      TARGET = plotcurve
      TEMPLATE = app
    EOS
    (testpath/"plotcurve.pro").append_lines "include (#{prefix}/features/qwt.prf)\n"
    if OS.mac?
      (testpath/"plotcurve.pro").append_lines "LIBS += -framework qwt\n"
    elsif OS.linux?
      (testpath/"plotcurve.pro").append_lines "LIBS += -lqwt\n"
    end
    (testpath/"test.cpp").write <<~EOS
      #include <qwt_plot_curve.h>
      int main() {
        QwtPlotCurve *curve1 = new QwtPlotCurve("Curve 1");
        return (curve1 == NULL);
      }
    EOS

    system "qmake", testpath/"plotcurve.pro"
    system "make"
    assert_predicate testpath/"plotcurve", :exist?
    assert_predicate testpath/"test.o", :exist?
    system "./plotcurve"
  end
end

__END__
diff --git a/designer/designer.pro b/designer/designer.pro
index c269e9d..c2e07ae 100644
--- a/designer/designer.pro
+++ b/designer/designer.pro
@@ -126,6 +126,16 @@ contains(QWT_CONFIG, QwtDesigner) {

     target.path = $${QWT_INSTALL_PLUGINS}
     INSTALLS += target
+
+    macx {
+        contains(QWT_CONFIG, QwtFramework) {
+            QWT_LIB = qwt.framework/Versions/$${QWT_VER_MAJ}/qwt
+        }
+        else {
+            QWT_LIB = libqwt.$${QWT_VER_MAJ}.dylib
+        }
+        QMAKE_POST_LINK = install_name_tool -change $${QWT_LIB} $${QWT_INSTALL_LIBS}/$${QWT_LIB} $(DESTDIR)$(TARGET)
+    }
 }
 else {
     TEMPLATE        = subdirs # do nothing
