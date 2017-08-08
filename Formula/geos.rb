class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "http://download.osgeo.org/geos/geos-3.6.2.tar.bz2"
  sha256 "045a13df84d605a866602f6020fc6cbf8bf4c42fb50de237a08926e1d7d7652a"

  bottle do
    cellar :any
    sha256 "68d2c33f2cff05d4ba5ab476adbce4398db16e6ae9815cea33e13d6e685f0ca0" => :x86_64_linux
  end

  option :cxx11
  option "without-python", "Do not build the Python extension"
  option "with-ruby", "Build the ruby extension"

  depends_on "swig" => :build if build.with?("python") || build.with?("ruby")
  depends_on :python unless OS.mac?

  def install
    ENV.cxx11 if build.cxx11?

    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]

    args << "--enable-python" if build.with?("python")
    args << "--enable-ruby" if build.with?("ruby")

    ENV["PYTHON"] = Formula["python"].bin/"python2"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
