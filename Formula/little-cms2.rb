# little-cms2: Build a bottle for Linuxbrew
class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.8/lcms2-2.8.tar.gz"
  sha256 "66d02b229d2ea9474e62c2b6cd6720fde946155cd1d0d2bffdab829790a0fb22"

  bottle do
    cellar :any
    sha256 "a30d5d21c70d1083446810bfa4d3573f6405aabcf69f7426efc744cd0bef30cb" => :x86_64_linux
  end

  option :universal

  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert File.exist?("out.jpg")
  end
end
