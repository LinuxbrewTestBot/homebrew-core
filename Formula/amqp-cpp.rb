class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v3.1.0.tar.gz"
  sha256 "0569fde9571dbbdcfab90550e602e771f9a8b2c5f62c85e089ed5cebdf1cfaef"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e703d677d87f1640700f7ca62ab2545ba42bdab54a5361bf4891e22185858460" => :x86_64_linux
  end

  needs :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    system "cmake", "-DBUILD_SHARED=ON", "-DCMAKE_MACOSX_RPATH=1", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <amqpcpp.h>
      int main()
      {
        return 0;
      }
      EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-o",
                    "test", *("-lc++" if OS.mac?), "-lamqpcpp"
    system "./test"
  end
end
