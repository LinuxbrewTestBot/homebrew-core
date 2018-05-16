# aria2: Build a bottle for Linuxbrew
class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.34.0/aria2-1.34.0.tar.xz"
  sha256 "3a44a802631606e138a9e172a3e9f5bcbaac43ce2895c1d8e2b46f30487e77a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e60cc264d9ca640e0b9e2936f53379151560eb6867ec59eb9809a4cd9bc8ed9" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libssh2" => :optional
  depends_on "openssl" unless OS.mac?

  needs :cxx14

  def install
    # Fix "error: use of undeclared identifier 'make_unique'"
    # Reported upstream 15 May 2018 https://github.com/aria2/aria2/issues/1198
    inreplace "src/bignum.h", "make_unique", "std::make_unique"
    inreplace "configure", "-std=c++11", "-std=c++14"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      #{OS.mac? ? "--with-appletls" : "--without-appletls"}
      #{OS.mac? ? "--without-openssl" : "--with-openssl"}
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]

    args << "--with-libssh2" if build.with? "libssh2"

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "https://brew.sh/"
    assert_predicate testpath/"index.html", :exist?, "Failed to create index.html!"
  end
end
