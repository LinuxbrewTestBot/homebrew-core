# flex: Build a bottle for Linuxbrew
class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "http://flex.sourceforge.net"
  url "https://github.com/westes/flex/releases/download/v2.6.1/flex-2.6.1.tar.xz"
  sha256 "2c7a412c1640e094cb058d9b2fe39d450186e09574bebb7aa28f783e3799103f"

  bottle do
    sha256 "99a56a96dba155ca50e63a5604b2bbac570c39b22cd72c0e70639776fc5034ea" => :x86_64_linux
  end

  keg_only :provided_by_osx, "Some formulae require a newer version of flex."

  depends_on "gettext"
  depends_on "homebrew/dupes/m4" unless OS.mac?
  depends_on "bison" => :build unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-shared",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.flex").write <<-EOS.undent
      CHAR   [a-z][A-Z]
      %%
      {CHAR}+      printf("%s", yytext);
      [ \\t\\n]+   printf("\\n");
      %%
      int main()
      {
        yyin = stdin;
        yylex();
      }
    EOS
    system "#{bin}/flex", "test.flex"
    system ENV.cc, "lex.yy.c", "-L#{lib}", "-lfl", "-o", "test"
    assert_equal shell_output("echo \"Hello World\" | ./test"), <<-EOS.undent
      Hello
      World
    EOS
  end
end
