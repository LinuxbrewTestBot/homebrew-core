# amqp-cpp: Build a bottle for Linuxbrew
class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v3.1.0.tar.gz"
  sha256 "0569fde9571dbbdcfab90550e602e771f9a8b2c5f62c85e089ed5cebdf1cfaef"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4279fef93269d5a69117037af451d257933e253466e38d5e5403694721294c80" => :high_sierra
    sha256 "b0e6af21fe4bd328b4339e3668e7b9a7a1447a057aa3f5cdff198056ec8326c9" => :sierra
    sha256 "5817f1cb45cbd4b336500c05c6254219a80b3f0d42e035107d4365e4744e496a" => :el_capitan
    sha256 "d83d3a6773e3a462826163a8608fed73e07063464cefe9e6238864433688ced7" => :x86_64_linux
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    ENV.cxx11

    system "cmake", "-DBUILD_SHARED=ON",
                    "-DCMAKE_MACOSX_RPATH=1",
                    "-DAMQP-CPP_LINUX_TCP=ON",
                    *std_cmake_args
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
