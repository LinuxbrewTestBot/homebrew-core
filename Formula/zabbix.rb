class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.4.5/zabbix-4.4.5.tar.gz"
  sha256 "94a897825b062e17b34767c0864305cee6a87476dda8bee88dcf845b24bed0ea"

  bottle do
    sha256 "8b5241f2ae3d2596647e0390841273f27221c8646fbcfd23f99bde42b00f5765" => :catalina
    sha256 "e1bad10d02efec6ce026fabd7e6150bbde66f8ce7a52f6fefae19c42190e3da4" => :mojave
    sha256 "1384af57bc0c760b7a23ba8f62e386ab3b627d1ea498e60b5360258ab00af216" => :high_sierra
    sha256 "75301a387655d6e26305fda51a65ec533cfebdb5e069f7a314c6abf7b33ce2da" => :x86_64_linux
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def brewed_or_shipped(db_config)
    brewed_db_config = "#{HOMEBREW_PREFIX}/bin/#{db_config}"
    (File.exist?(brewed_db_config) && brewed_db_config) || which(db_config)
  end

  def install
    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    if OS.mac?
      args << "--with-iconv=#{sdk}/usr"
    end

    if OS.mac? && MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "configure", "clock_gettime(CLOCK_REALTIME, &tp);",
                             "undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
