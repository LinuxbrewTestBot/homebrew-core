# tippecanoe: Build a bottle for Linuxbrew
class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.12.5.tar.gz"
  sha256 "119ad45496bea75b7985c6b2b5ee95ddfa965ae099990ed8841973a95ffdfbae"

  bottle do
    cellar :any_skip_relocation
    sha256 "29b292d50c8ad0cc1ea0278c30698095249942ae148e8a26d21b734fd3e3a5db" => :x86_64_linux
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
