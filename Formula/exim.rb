# exim: Build a bottle for Linuxbrew
class Exim < Formula
  desc "Complete replacement for sendmail"
  homepage "https://exim.org"
  url "https://ftp.exim.org/pub/exim/exim4/exim-4.90.1.tar.xz"
  sha256 "5c98dfd12043be5751b88ef64d5363cd99284236eaeec6316b062a7628c2f726"

  bottle do
    sha256 "4e7766c4ac809c41d87d258c056aa706f4704acd5e28e15768ac1ae5b3b9673f" => :high_sierra
    sha256 "809ae3690e6581365f97aca7222020eb2e4ebdc31b8f529ae3fb35a38f680046" => :sierra
    sha256 "bf8f087f3e15750160b825c2dc5a93c82115ae68568938ef086fe7a18f13e726" => :el_capitan
    sha256 "601a068068cb48eb054d51e7fd6a2b3e442afe9a06693990ae8c0829b6ee733f" => :x86_64_linux
  end

  deprecated_option "support-maildir" => "with-maildir"
  option "with-maildir", "Support delivery in Maildir format"

  depends_on "pcre"
  depends_on "berkeley-db@4"
  depends_on "openssl"

  def install
    cp "src/EDITME", "Local/Makefile"
    inreplace "Local/Makefile" do |s|
      s.remove_make_var! "EXIM_MONITOR"
      s.change_make_var! "EXIM_USER", ENV["USER"]
      s.change_make_var! "SYSTEM_ALIASES_FILE", etc/"aliases"
      s.gsub! "/usr/exim/configure", etc/"exim.conf"
      s.gsub! "/usr/exim", prefix
      s.gsub! "/var/spool/exim", var/"spool/exim"
      # https://trac.macports.org/ticket/38654
      s.gsub! 'TMPDIR="/tmp"', "TMPDIR=/tmp"
      s << "SUPPORT_MAILDIR=yes\n" if build.with? "maildir"
      s << "AUTH_PLAINTEXT=yes\n"
      s << "SUPPORT_TLS=yes\n"
      s << "TLS_LIBS=-lssl -lcrypto\n"
      s << "TRANSPORT_LMTP=yes\n"

      # For non-/usr/local HOMEBREW_PREFIX
      s << "LOOKUP_INCLUDE=-I#{HOMEBREW_PREFIX}/include\n"
      s << "LOOKUP_LIBS=-L#{HOMEBREW_PREFIX}/lib\n"
    end

    bdb4 = Formula["berkeley-db@4"]

    mv Dir["OS/unsupported/*Darwin*"], "OS"

    inreplace "OS/Makefile-Darwin" do |s|
      s.remove_make_var! %w[CC CFLAGS]
      # Add include and lib paths for BDB 4
      s.gsub! "# Exim: OS-specific make file for Darwin (Mac OS X).", "INCLUDE=-I#{bdb4.include}"
      s.gsub! "DBMLIB =", "DBMLIB=#{bdb4.lib}/libdb-4.dylib"
    end

    # The compile script ignores CPPFLAGS
    ENV.append "CFLAGS", ENV.cppflags

    ENV.deparallelize # See: https://lists.exim.org/lurker/thread/20111109.083524.87c96d9b.en.html
    system "make"
    system "make", "INSTALL_ARG=-no_chown", "install"
    man8.install "doc/exim.8"
    (bin/"exim_ctl").write startup_script
  end

  # Inspired by MacPorts startup script. Fixes restart issue due to missing setuid.
  def startup_script; <<~EOS
    #!/bin/sh
    PID=#{var}/spool/exim/exim-daemon.pid
    case "$1" in
    start)
      echo "starting exim mail transfer agent"
      #{bin}/exim -bd -q30m
      ;;
    restart)
      echo "restarting exim mail transfer agent"
      /bin/kill -15 `/bin/cat $PID` && sleep 1 && #{bin}/exim -bd -q30m
      ;;
    stop)
      echo "stopping exim mail transfer agent"
      /bin/kill -15 `/bin/cat $PID`
      ;;
    *)
      echo "Usage: #{bin}/exim_ctl {start|stop|restart}"
      exit 1
      ;;
    esac
    EOS
  end

  def caveats; <<~EOS
    Start with:
      exim_ctl start
    Don't forget to run it as root to be able to bind port 25.
    EOS
  end

  test do
    assert_match "Mail Transfer Agent", shell_output("#{bin}/exim --help 2>&1", 1)
  end
end
