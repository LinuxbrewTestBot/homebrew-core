class Libusb < Formula
  desc "Library for USB device access"
  homepage "http://libusb.info"
  url "https://github.com/libusb/libusb/releases/download/v1.0.20/libusb-1.0.20.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2"
  sha256 "cb057190ba0a961768224e4dc6883104c6f945b2bf2ef90d7da39e7c1834f7ff"

  bottle do
    cellar :any
    revision 1
    sha256 "61de2c4a81871b5d0e7cb4fae460e93e2d407defbb41507bb9316cdfb9d3b6dd" => :x86_64_linux
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "without-runtime-logging", "Build without runtime logging functionality"
  option "with-default-log-level-debug", "Build with default runtime log level of debug (instead of none)"

  deprecated_option "no-runtime-logging" => "without-runtime-logging"

  depends_on "systemd" if OS.linux? # for libudev

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-log" if build.without? "runtime-logging"
    args << "--enable-debug-log" if build.with? "default-log-level-debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples"), testpath
    cd "examples" do
      system ENV.cc, "-L#{lib}", "-I#{include}/libusb-1.0",
             "listdevs.c", "-o", "test", "-lusb-1.0"
      system "./test"
    end
  end
end
