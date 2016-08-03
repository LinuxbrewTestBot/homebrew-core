# zsh: Build a bottle for Linuxbrew
class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "http://www.zsh.org/"

  stable do
    url "https://downloads.sourceforge.net/project/zsh/zsh/5.2/zsh-5.2.tar.gz"
    mirror "http://www.zsh.org/pub/zsh-5.2.tar.gz"
    sha256 "fa924c534c6633c219dcffdcd7da9399dabfb63347f88ce6ddcd5bb441215937"

    # We cannot build HTML doc on HEAD, because yodl which is required for
    # building zsh.texi is not available.
    option "with-texi2html", "Build HTML documentation"
    depends_on "texi2html" => [:build, :optional]
  end

  bottle do
    revision 2
    sha256 "1a60f346ce55fac068a5b78218e45c35f167e23b1c8c1af773a5a65bcb729a29" => :x86_64_linux
  end

  head do
    url "git://git.code.sf.net/p/zsh/code"
    depends_on "autoconf" => :build
  end

  option "without-etcdir", "Disable the reading of Zsh rc files in /etc"

  deprecated_option "disable-etcdir" => "without-etcdir"

  depends_on "gdbm"
  depends_on "pcre"
  depends_on "texinfo" unless OS.mac?
  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    system "Util/preconfig" if build.head?

    args = %W[
      --prefix=#{prefix}
      --enable-fndir=#{pkgshare}/functions
      --enable-scriptdir=#{pkgshare}/scripts
      --enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions
      --enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts
      --enable-runhelpdir=#{pkgshare}/help
      --enable-cap
      --enable-maildir-support
      --enable-multibyte
      --enable-pcre
      --enable-zsh-secure-free
      --with-tcsetpgrp
    ]

    if build.without? "etcdir"
      args << "--disable-etcdir"
    else
      args << "--enable-etcdir=/etc"
    end

    system "./configure", *args

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    if build.head?
      # disable target install.man, because the required yodl comes neither with OS X nor Homebrew
      # also disable install.runhelp and install.info because they would also fail or have no effect
      system "make", "install.bin", "install.modules", "install.fns"
    else
      system "make", "install"
      system "make", "install.info"
      system "make", "install.html" if build.with? "texi2html"
    end
  end

  def caveats; <<-EOS.undent
    In order to use this build of zsh as your login shell,
    it must be added to /etc/shells.
    Add the following to your zshrc to access the online help:
      unalias run-help
      autoload run-help
      HELPDIR=#{HOMEBREW_PREFIX}/share/zsh/help
    EOS
  end

  test do
    assert_equal "homebrew\n",
      shell_output("#{bin}/zsh -c 'echo homebrew'")
  end
end
