class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://freedesktop.org/wiki/Software/pkg-config/"
  url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/pkg-config-0.29.2.tar.gz"
  sha256 "6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591"
  revision 1 unless OS.mac?

  bottle do
    sha256 "2f706d962b15e3af2adb10cd8625830939ad0df8fcf433eb28e98e17f68143a0" => :x86_64_linux
  end

  def install
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
    ]
    if OS.mac?
      pc_path += %W[/usr/local/lib/pkgconfig /usr/lib/pkgconfig #{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}"]
    else
      pc_path << "#{HOMEBREW_LIBRARY}/Homebrew/os/linux/pkgconfig"
    end

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-host-tool",
                          "--with-internal-glib",
                          "--with-pc-path=#{pc_path.join(File::PATH_SEPARATOR)}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "#{HOMEBREW_PREFIX}/lib/pkgconfig:", shell_output("#{bin}/pkg-config pkg-config --variable pc_path")
    system "#{bin}/pkg-config", "--libs", "libpcre" if OS.mac?
  end
end
