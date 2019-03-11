# lolcat: Build a bottle for Linuxbrew
class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag      => "v99.9.21",
      :revision => "58d5b5ba6d1d3f70aa72b140ee84034aaab91a9c"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "e6782890a9d544a17aa6a9011474eaefea4f7422915177946e88985619aa2367" => :mojave
    sha256 "5cbddd57ab46ac3d73a43ea5ef6264096910d337c815948ec603211cb5c5455f" => :high_sierra
    sha256 "6ce278781b578837a6e23164c37b6515292a54de586318288795ce16a808d654" => :sierra
    sha256 "ceff03af3860acba2818febe9a4b113f093cb87c3541d472183f0d8a3f3f6017" => :x86_64_linux
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "lolcat.gemspec"
    system "gem", "install", "lolcat-#{version}.gem"
    bin.install libexec/"bin/lolcat"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
    man6.install "man/lolcat.6"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      This is
      a test
    EOS

    system bin/"lolcat", "test.txt"
  end
end
