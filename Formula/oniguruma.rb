# oniguruma: Build a bottle for Linuxbrew
class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.0.0/onig-6.0.0.tar.gz"
  sha256 "0cd75738a938faff4a48c403fb171e128eb9bbd396621237716dbe98c3ecd1af"

  bottle do
    cellar :any
    sha256 "02f932d6008bb404f9908c8ef2116df982e77f57a6f6f01341f59ab4120248f3" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
