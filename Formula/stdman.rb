class Stdman < Formula
  desc "Formatted C++11/14/17 stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/2018.03.11.tar.gz"
  sha256 "d29e6b34cb5ba9905360cee6adcdf8c49e7f11272521bf2e10b42917486840e8"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "524d5bddc6b76787604a8fe8a4843f4032d89e7c96d768ad9ecb644bad03d2f2" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "man", "-w", "std::string"
  end
end
