# telegram-cli: Build a bottle for Linuxbrew
class TelegramCli < Formula
  desc "Command-line interface for Telegram"
  homepage "https://github.com/vysheng/tg"
  url "https://github.com/vysheng/tg.git",
      :tag      => "1.3.1",
      :revision => "5935c97ed05b90015418b5208b7beeca15a6043c"
  revision 3
  head "https://github.com/vysheng/tg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c250bcdcee5852b694b513765dd6a75d756482399ba50eb757fbf316d6a9f8c" => :mojave
    sha256 "64fb7ce4cbea47744a7fd0e735acb355b8b0765b1b4d7af72aef71665d676382" => :high_sierra
    sha256 "df7a9db972b81626209015fc673b10e2eabde37c266f12c7cf9a3a0f8041aa85" => :sierra
    sha256 "3353767b0f49fc69f464f2cc9ebb276b90eb73f6ad2bca267b8139799fef3740" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libconfig"
  depends_on "libevent"
  depends_on "openssl"
  depends_on "readline"
  uses_from_macos "zlib"

  # Look for the configuration file under /usr/local/etc rather than /etc on OS X.
  # Pull Request: https://github.com/vysheng/tg/pull/1306
  if OS.mac?
    patch do
      url "https://github.com/vysheng/tg/pull/1306.patch?full_index=1"
      sha256 "1cdaa1f3e1f7fd722681ea4e02ff31a538897ed9d704c61f28c819a52ed0f592"
    end
  end

  def install
    args = %W[
      --prefix=#{prefix}
      CFLAGS=-I#{Formula["readline"].include}
      CPPFLAGS=-I#{Formula["readline"].include}
      LDFLAGS=-L#{Formula["readline"].lib}
      --disable-liblua
      --disable-python
    ]

    system "./configure", *args
    system "make"

    bin.install "bin/telegram-cli" => "telegram"
    (etc/"telegram-cli").install "server.pub"
  end

  test do
    assert_match "telegram-cli", (shell_output "#{bin}/telegram -h", 1)
  end
end
