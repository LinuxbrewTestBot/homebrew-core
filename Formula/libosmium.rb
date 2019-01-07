# libosmium: Build a bottle for Linuxbrew
class Libosmium < Formula
  desc "Fast and flexible C++ library for working with OpenStreetMap data"
  homepage "https://osmcode.org/libosmium/"
  url "https://github.com/osmcode/libosmium/archive/v2.15.0.tar.gz"
  sha256 "16387d206977717e5982907a380c6f0fb6e0c02c96a7e7d2d23e2d516ae25315"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "51876fb1bc9ba3495dbf098737e891296d3c9aca69a1100b350fe75c078a5c4a" => :mojave
    sha256 "c6d4232ba9c320f939116309788b3a8dec335531294cc683d7fc043ba1232ac0" => :high_sierra
    sha256 "c6d4232ba9c320f939116309788b3a8dec335531294cc683d7fc043ba1232ac0" => :sierra
    sha256 "0ea5a0120002f0ae0747ab71a904f2692c85d0402dabb901253b35406ea61627" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "expat" unless OS.mac?

  resource "protozero" do
    url "https://github.com/mapbox/protozero/archive/v1.6.3.tar.gz"
    sha256 "c5d3c71f5fb56d867ff0536e55cd7a3f2eb0d09f6ebbf636b0fde4f0e12552f5"
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    resource("protozero").stage { libexec.install "include" }
    system "cmake", ".", "-DINSTALL_GDALCPP=ON",
                         "-DINSTALL_UTFCPP=ON",
                         "-DPROTOZERO_INCLUDE_DIR=#{libexec}/include",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.osm").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6" generator="handwritten">
        <node id="1" lat="0.001" lon="0.001" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <node id="2" lat="0.002" lon="0.002" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <way id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <nd ref="1"/>
          <nd ref="2"/>
          <tag k="name" v="line"/>
        </way>
        <relation id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <member type="node" ref="1" role=""/>
          <member type="way" ref="1" role=""/>
        </relation>
      </osm>
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <cstdlib>
      #include <iostream>
      #include <osmium/io/xml_input.hpp>

      int main(int argc, char* argv[]) {
        osmium::io::File input_file{argv[1]};
        osmium::io::Reader reader{input_file};
        while (osmium::memory::Buffer buffer = reader.read()) {}
        reader.close();
      }
    EOS

    system ENV.cxx, "-std=c++11", *("-stdlib=libc++" if OS.mac?), "-o", "libosmium_read", "test.cpp", "-lexpat", *("-pthread" unless OS.mac?)
    system "./libosmium_read", "test.osm"
  end
end
