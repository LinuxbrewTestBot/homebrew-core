# check: Build a bottle for Linuxbrew
class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://github.com/libcheck/check/releases/download/0.11.0/check-0.11.0.tar.gz"
  sha256 "24f7a48aae6b74755bcbe964ce8bc7240f6ced2141f8d9cf480bc3b3de0d5616"

  bottle do
    cellar :any
    sha256 "749a01991f3a3fab473381d080155f8256c06bee3b9ba6ebb2125c6f117b6a88" => :sierra
    sha256 "b117fb498e9adde74822cfa4f2f430d24ba5c83464fe489c7e733e022d0037ea" => :el_capitan
    sha256 "99baff1f5da1e327096a9768904ca90a07a9e18bf883561f41f6c8b77c5a38fe" => :yosemite
    sha256 "80f8278f7d9c9d634adf9f449bfce575bdcaf0f5589116dcd18839c136410b4f" => :x86_64_linux
  end

  depends_on "gawk" unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.tc").write <<-EOS.undent
      #test test1
      ck_assert_msg(1, "This should always pass");
    EOS

    system "#{bin/"checkmk"} test.tc > test.c"

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheck", "-o", "test"
    system "./test"
  end
end
