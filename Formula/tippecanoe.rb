# tippecanoe: Build a bottle for Linuxbrew
class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.12.9.tar.gz"
  sha256 "6a68c82c075bf4c24b03de8b027d659245cec8cf8a532e3f3b515b12b386173d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d261e30e00178fd05694c3af68270929d19822bb1abc9dd42aa0f60d4b1268e3" => :x86_64_linux
  end

  depends_on "sqlite" unless OS.mac?

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<-EOS.undent
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert File.exist?("#{testpath}/test.mbtiles"), "tippecanoe generated no output!"
  end
end
