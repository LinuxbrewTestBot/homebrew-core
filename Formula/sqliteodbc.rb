class Sqliteodbc < Formula
  desc "SQLite ODBC driver"
  homepage "http://www.ch-werner.de/sqliteodbc/"
  url "http://www.ch-werner.de/sqliteodbc/sqliteodbc-0.9996.tar.gz"
  sha256 "8afbc9e0826d4ff07257d7881108206ce31b5f719762cbdb4f68201b60b0cb4e"

  bottle do
    cellar :any
    sha256 "7d825f83232825a51c8fd871368a2ff8cce3a76fe9ba1646f20e15f121ecf79e" => :high_sierra
    sha256 "907c1b32398eb7f3276e1da956723ac27868d9bcae27fb55ef76277cf2f67cb7" => :sierra
    sha256 "7c550f77c2db4e4927b9f23ed8a57610727b438f6a0fad98e1adecee3c8c1aa1" => :el_capitan
    sha256 "bcb8d2161664a9806988ec6a9eedd6a723a85b3431a65b558dd63e2cfe89b529" => :x86_64_linux
  end

  depends_on "sqlite"
  depends_on "unixodbc"

  def install
    lib.mkdir
    system "./configure", "--prefix=#{prefix}", "--with-odbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
    lib.install_symlink "#{lib}/libsqlite3odbc.dylib" => "libsqlite3odbc.so"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libsqlite3odbc.so")
    assert_equal "SUCCESS: Loaded #{lib}/libsqlite3odbc.so\n", output
  end
end
