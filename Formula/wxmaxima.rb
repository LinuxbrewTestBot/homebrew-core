# wxmaxima: Build a bottle for Linuxbrew
class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://andrejv.github.io/wxmaxima"
  url "https://github.com/andrejv/wxmaxima/archive/Version-18.02.0.tar.gz"
  sha256 "727303bd26bdc7eb72dea0b0fcfa60c0180993430d55a4e3700c92eb5e16790e"
  head "https://github.com/andrejv/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "1cab5b45e11c9a53b04e88e49226d2e9eb0965f1367c86ad30915694cea1eba6" => :high_sierra
    sha256 "b44af0b7c1a8aac7d5a5270eaafa9d21c1d3e84940784e6fe343860d9b1eefbd" => :sierra
    sha256 "f742fa1359c964822066034bf08d7a454e5d73546e2138f63deb4de79ae5c9d6" => :el_capitan
    sha256 "40ba9a3962c2039ae274544cf677bd8abd24c6f75ebbbde77a9fe2589230f3c6" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "wxmac"

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j16" if ENV["CIRCLECI"]

    system "cmake", ".", *std_cmake_args
    system "make", "install"
    prefix.install "wxMaxima.app" if OS.mac?
  end

  def caveats; <<~EOS
    When you start wxMaxima the first time, set the path to Maxima
    (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

    Enable gnuplot functionality by setting the following variables
    in ~/.maxima/maxima-init.mac:
      gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
      draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end

  test do
    # Test is disbaled on Linux as circle has no X (Error: Unable to initialize GTK+, is DISPLAY set properly)
    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1", 255) if OS.mac?
  end
end
