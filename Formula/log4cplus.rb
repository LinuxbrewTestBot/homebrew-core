class Log4cplus < Formula
  desc "Logging Framework for C++"
  homepage "https://sourceforge.net/p/log4cplus/wiki/Home/"
  url "https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/2.0.0/log4cplus-2.0.0.tar.xz"
  sha256 "8c85e769c3dbec382ed4db91f15e5bc24ba979f810262723781f2fc596339bf4"

  bottle do
    cellar :any
    sha256 "9a9d545c10950c742a0401481dbecd25e67bb13882136d8e9dfbb5ccdc7dc3dc" => :x86_64_linux
  end

  needs :cxx11

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j12" if ENV["CIRCLECI"]

    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
