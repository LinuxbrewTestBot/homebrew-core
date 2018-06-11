# kitchen-sync: Build a bottle for Linuxbrew
class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/1.0.tar.gz"
  sha256 "a25bfbf56b4a49f69521ed57d290ad8cb7e190a9e354115bd86e41e9a80cd031"
  revision 1
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "223a6538cfa197e954c0105ed7cb362b03244e17a9d71680ca037b88efec1f7a" => :x86_64_linux
  end

  deprecated_option "without-mysql" => "without-mysql-client"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yaml-cpp"
  depends_on "mysql-client" => :recommended
  depends_on "postgresql" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from a://b/ --to c://d/ 2>&1")
    assert_match "Finished Kitchen Syncing", output
  end
end
