# mysql-connector-c++: Build a bottle for Linuxbrew
class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-1.1.9.tar.gz"
  sha256 "3e31847a69a4e5c113b7c483731317ec4533858e3195d3a85026a0e2f509d2e4"
  revision 2

  bottle do
    cellar :any
    sha256 "da918a746cdf3337c900ff475c9503356bfb1988c3e90a340d286cec69032326" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on "mysql-client"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cppconn/driver.h>
      int main(void) {
        try {
          sql::Driver *driver = get_driver_instance();
        } catch (sql::SQLException &e) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["mysql-client"].opt_include}",
                    "-L#{lib}", "-lmysqlcppconn", "-o", "test"
    system "./test"
  end
end
