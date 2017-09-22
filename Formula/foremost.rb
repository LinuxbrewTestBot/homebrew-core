# foremost: Build a bottle for Linuxbrew
class Foremost < Formula
  desc "Console program to recover files based on their headers and footers"
  homepage "https://foremost.sourceforge.io/"
  url "https://foremost.sourceforge.io/pkg/foremost-1.5.7.tar.gz"
  sha256 "502054ef212e3d90b292e99c7f7ac91f89f024720cd5a7e7680c3d1901ef5f34"

  bottle do
    rebuild 1
    sha256 "039d8f237f0c1247c23309a63ccba896993f4d57dc1a0db2fbc8b0d7fba936ab" => :x86_64_linux
  end

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr/", "#{prefix}/"
      s.change_make_var! "RAW_CC", ENV.cc
      s.change_make_var! "RAW_FLAGS", ENV.cflags
    end

    if OS.mac?
      system "make", "mac"
    else
      inreplace "config.c", "/usr/local/etc/", "#{etc}/"
      system "make"
    end

    bin.install "foremost"
    man8.install "foremost.8.gz"
    etc.install "foremost.conf" => "foremost.conf.default"
  end
end
