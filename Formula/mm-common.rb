# mm-common: Build a bottle for Linuxbrew
class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/0.9/mm-common-0.9.12.tar.xz"
  sha256 "ceffdcce1e5b52742884c233ec604bf6fded12eea9da077ce7a62c02c87e7c0b"

  bottle do
    cellar :any_skip_relocation
    sha256 "42c9654bebbc472d90bc31d14e0832d55367d8d86d6750ab546a129a48de342b" => :high_sierra
    sha256 "42c9654bebbc472d90bc31d14e0832d55367d8d86d6750ab546a129a48de342b" => :sierra
    sha256 "42c9654bebbc472d90bc31d14e0832d55367d8d86d6750ab546a129a48de342b" => :el_capitan
    sha256 "85398e2c7a5ab5f48e1e03476b3c774e6afba282a3f4ea7842176838b26efe6c" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
