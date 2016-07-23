# zshdb: Build a bottle for Linuxbrew
class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/0.92/zshdb-0.92.tar.bz2"
  sha256 "faeb75dc12f4eafff195af103fde4fc5aabc258b7ed902b1aad6d4659f3ae744"

  bottle do
    cellar :any_skip_relocation
    sha256 "eff5f5d8cde7417ccd4744bcc7a4c01a63231b8d8e7ce342276dfa729a50aaa6" => :x86_64_linux
  end

  head do
    url "https://github.com/rocky/zshdb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "zsh"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zsh=#{HOMEBREW_PREFIX}/bin/zsh"
    system "make", "install"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/zshdb -c 'echo test'") do |stdin, stdout, _|
      stdin.write "exit\n"
      assert_match(/That's all, folks/, stdout.read)
    end
  end
end
