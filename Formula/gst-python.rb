class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.12.2.tar.xz"
  sha256 "f4cc32ad46a653e1ae2f27ac2a16078b00075c9106b2784a1a8d1f31c5069e47"
  revision 1 if OS.linux? # revision for python 2.7.13_1

  bottle do
    sha256 "cd0b2693718a26b282762b2c2a9b65582461f4f657c5480a77e7675773f326e1" => :x86_64_linux
  end

  option "without-python", "Build without python 2 support"

  depends_on :python3 => :optional
  depends_on "gst-plugins-base"

  depends_on "pygobject3" if build.with? "python"
  depends_on "pygobject3" => "with-python3" if build.with? "python3"

  link_overwrite "lib/python2.7/site-packages/gi/overrides"

  def install
    if build.with?("python") && build.with?("python3")
      # Upstream does not support having both Python2 and Python3 versions
      # of the plugin installed because apparently you can load only one
      # per process, so GStreamer does not know which to load.
      odie "Options --with-python and --with-python3 are mutually exclusive."
    end

    Language::Python.each_python(build) do |python, version|
      # pygi-overrides-dir switch ensures files don't break out of sandbox.
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--with-pygi-overrides-dir=#{lib}/python#{version}/site-packages/gi/overrides",
                            "PYTHON=#{python}"
      system "make", "install"
    end
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "python"
    Language::Python.each_python(build) do |python, _version|
      # Without gst-python raises "TypeError: object() takes no parameters"
      system python, "-c", <<-EOS.undent
        import gi
        gi.require_version('Gst', '1.0')
        from gi.repository import Gst
        print (Gst.Fraction(num=3, denom=5))
        EOS
    end
  end
end
