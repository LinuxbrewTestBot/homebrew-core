# argtable: Build a bottle for Linuxbrew
class Argtable < Formula
  desc "ANSI C library for parsing GNU-style command-line options"
  homepage "http://argtable.sourceforge.net"
  url "https://downloads.sourceforge.net/project/argtable/argtable/argtable-2.13/argtable2-13.tar.gz"
  version "2.13"
  sha256 "8f77e8a7ced5301af6e22f47302fdbc3b1ff41f2b83c43c77ae5ca041771ddbf"

  bottle do
    cellar :any
    sha256 "0a720e738557215bf1b58fa642ec2fc51971da38e98b987862fcd05cc54756f7" => :el_capitan
    sha256 "9e9d1451712580f090f0078ec7774a0daeb1057be3b1762e3d8465264d969432" => :yosemite
    sha256 "7081198c76023e34380d35682b7a4274a9faf98d3e3e3fa2a9fa801e0a320a8c" => :mavericks
    sha256 "2cb2fa7361e54356f2c353b15fa39096d29a2cd2dd452e5d79e106420a304cdf" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
