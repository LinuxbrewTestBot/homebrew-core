# dash: Build a bottle for Linuxbrew
class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.9.tar.gz"
  sha256 "92793b14c017d79297001556389442aeb9e3c1cc559fd178c979169b1a47629c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7947782a3591d0bdc503c924b0d17d09e475143ca49bf8bfd5cf7736bd9dba67" => :x86_64_linux
  end

  head do
    url "https://git.kernel.org/pub/scm/utils/dash/dash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking",
                          "--enable-fnmatch",
                          "--enable-glob"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
