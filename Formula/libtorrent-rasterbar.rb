class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_2_3/libtorrent-rasterbar-1.2.3.tar.gz"
  sha256 "1582fdbbd0449bcfe4ffae2ccb9e5bf0577459a32bb25604e01accb847da1a2d"

  bottle do
    cellar :any
    sha256 "66937184ea06abd847e368a49fb81a083c4559ca332ad67e05d5a8e94d05740e" => :catalina
    sha256 "f70fda7a90824aa39b22dd1559d902d0e27d03c0d231f4381f79f1cf0fab6b84" => :mojave
    sha256 "78c7076eaa802ca7a3b40a2132592d0c39558d8278ab082cd333d405701a81a5" => :high_sierra
    sha256 "5b2330ee64ed63b90403eef2fa9c6d25d78ad90d1eb5ee4301a5b67279630d7b" => :x86_64_linux
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-encryption
      --enable-python-binding
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-boost-python=boost_python37-mt
      PYTHON=python3
    ]

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
    libexec.install "examples"
  end

  test do
    if OS.mac?
      system ENV.cxx, "-std=c++11", "-I#{Formula["boost"].include}/boost",
                      "-L#{lib}", "-ltorrent-rasterbar",
                      "-L#{Formula["boost"].lib}", "-lboost_system",
                      "-framework", "SystemConfiguration",
                      "-framework", "CoreFoundation",
                      libexec/"examples/make_torrent.cpp", "-o", "test"
    else
      system ENV.cxx, libexec/"examples/make_torrent.cpp",
                      "-std=c++11",
                      "-I#{Formula["boost"].include}/boost", "-L#{Formula["boost"].lib}",
                      "-I#{include}", "-L#{lib}",
                      "-lpthread",
                      "-lboost_system",
                      "-ltorrent-rasterbar",
                      "-o", "test"
    end
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
