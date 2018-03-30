class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.11.4.tar.gz"
  sha256 "9d8f1eb7b0e29e9ab1168347c939cb7ae5dff00a39cef99e7ef033fd8f92737c"
  head "https://github.com/edenhill/librdkafka.git"
  revision 1 unless OS.mac?

  bottle do
    cellar :any
    sha256 "b2649691fd1f121b9039e74be8dfbf2fd969aa662e84e647cd06611c78c90b09" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "lzlib"
  depends_on "openssl"
  depends_on "lz4" => :recommended
  depends_on "python" unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end
