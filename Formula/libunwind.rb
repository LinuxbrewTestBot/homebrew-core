class Libunwind < Formula
  desc "C API for determining the call-chain of a program"
  homepage "http://www.nongnu.org/libunwind/"
  url "https://download.savannah.gnu.org/releases/libunwind/libunwind-1.1.tar.gz"
  sha256 "9dfe0fcae2a866de9d3942c66995e4b460230446887dbdab302d41a8aee8d09a"
  revision 1
  head "git://git.sv.gnu.org/libunwind.git"
  # tag "linuxbrew"

  depends_on "xz" => :optional

  bottle do
    cellar :any_skip_relocation
    sha256 "f275f0fb6e8e54c6d66460477400d554548177c9db2e19aa7e095c837f46cecb" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}",
      "--disable-debug", "--disable-dependency-tracking", "--disable-silent-rules",
      *("--enable-minidebuginfo" if build.with? "xz")
    system "make", "install"
  end

  test do
    system "pkg-config", "--libs", "libunwind"
  end
end
