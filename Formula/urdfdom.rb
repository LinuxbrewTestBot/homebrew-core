# urdfdom: Build a bottle for Linux
class Urdfdom < Formula
  desc "Unified Robot Description Format (URDF) parser"
  homepage "https://wiki.ros.org/urdf/"
  url "https://github.com/ros/urdfdom/archive/1.0.4.tar.gz"
  sha256 "8f3d56b0cbc4b84436d8baf4c8346cd2ee7ffb257bba5ddd9892c41bf516edc4"

  bottle do
    cellar :any
    sha256 "63a07e52b44a13128d93ce7d124f1d6731dfab1a746535b37df7ea2be24e83fe" => :catalina
    sha256 "b8efb5f82f50ce484f370e705bd9e1fc4d0d99e6e611a756d3b6c6d1a4b69ee0" => :mojave
    sha256 "f3ff98a1d51ffe041808c3d5f4a67edded6ae41bc65124d041e42c2284b2b7dd" => :high_sierra
    sha256 "0f002b544ebb0c818d3cd1af5b3768072df0d7e05d53c446ed45f35f1addd9b5" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "console_bridge"
  depends_on "tinyxml"
  depends_on "urdfdom_headers"

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <urdf_parser/urdf_parser.h>
      int main() {
        std::string xml_string =
          "<robot name='testRobot'>"
          "  <link name='link_0'>  "
          "  </link>               "
          "</robot>                ";
        urdf::parseURDF(xml_string);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lurdfdom_world", "-std=c++11",
                    "-o", "test"
    system "./test"
  end
end
