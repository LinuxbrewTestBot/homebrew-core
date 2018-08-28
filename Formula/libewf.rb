class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  version "20140608"
  sha256 "d14030ce6122727935fbd676d0876808da1e112721f3cb108564a4d9bf73da71"
  revision 2

  bottle do
    cellar :any
    sha256 "d0efe162fc1c3d527a00ebc07cdd1b56c28ee2aaa9af85357438520d741fcaee" => :x86_64_linux
  end

  devel do
    url "https://github.com/libyal/libewf/releases/download/20170703/libewf-experimental-20170703.tar.gz"
    sha256 "84fe12389abacf63dea2d921b636220bb7fda3262d1c467f6d445a5e31f53ade"
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  if OS.mac?
    depends_on :osxfuse => :optional
  else
    depends_on "bzip2"
    depends_on "libfuse" => :optional
    depends_on "zlib"
  end

  def install
    # Workaround bug in gcc-5 that causes the following error:
    # undefined reference to `libuna_ ...
    ENV.append_to_cflags "-std=gnu89" if ENV.cc == "gcc-5"

    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--with-libfuse=no" if build.without?(OS.mac? ? "osxfuse" : "libfuse")

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
