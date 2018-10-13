# collectd: Build a bottle for Linuxbrew
class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  url "https://collectd.org/files/collectd-5.8.0.tar.bz2"
  sha256 "b06ff476bbf05533cb97ae6749262cc3c76c9969f032bd8496690084ddeb15c9"
  revision OS.mac? ? 3 : 4

  bottle do
    sha256 "4c34b8bd58b65b573a54f88e9cf362cef892708479e6ab9a3ed8173c86be198c" => :mojave
    sha256 "5c81fed20b8c66cffa1ab39e0940f34a364527a52efdd2ecd3d9dceb622fc27d" => :high_sierra
    sha256 "6a23251995667772df3deb07c6c557bfadcc22dc6e06cdc95e7ad5827a381def" => :sierra
    sha256 "5e620a84e681bdc6d74586440648a1b9818d881a17823484afd211bd484ce0b3" => :x86_64_linux
  end

  head do
    url "https://github.com/collectd/collectd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libtool"
  depends_on "net-snmp"
  depends_on "riemann-client"
  depends_on "perl" unless OS.mac?
  depends_on "riemann-client"

  fails_with :clang do
    build 318
    cause <<~EOS
      Clang interacts poorly with the collectd-bundled libltdl,
      causing configure to fail.
    EOS
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-java
      --enable-write_riemann
    ]

    system "./build.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/collectd -f -C #{HOMEBREW_PREFIX}/etc/collectd.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/collectd</string>
          <string>-f</string>
          <string>-C</string>
          <string>#{etc}/collectd.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/collectd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/collectd.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    log = testpath/"collectd.log"
    (testpath/"collectd.conf").write <<~EOS
      LoadPlugin logfile
      <Plugin logfile>
        File "#{log}"
      </Plugin>
      LoadPlugin memory
    EOS
    begin
      pid = fork { exec sbin/"collectd", "-f", "-C", "collectd.conf" }
      sleep 1
      assert_predicate log, :exist?, "Failed to create log file"
      assert_match "plugin \"memory\" successfully loaded.", log.read
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
