class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-21.0.4.tar.gz"
  sha256 "8830c81042835070d72130a0df78058a5ccb8db9f93829310d93ed6e2e323e0d"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "b5457b76b0dfadf98c9a3b4b3e9ca8ad001d1e1087c4c2a842df4ec39a4b0c80" => :high_sierra
    sha256 "2e36c9c15eb2efee9ba3769545948f8e0e840043afdddcf9a3b07d953d7e6f52" => :sierra
    sha256 "a5ff810b70d952418099ed714dcc556c5b8d6148be5c042207590defd2756b80" => :el_capitan
  end

  option "without-hipe", "Disable building hipe; fails on various macOS systems"
  option "with-native-libs", "Enable native library compilation"
  option "with-dirty-schedulers", "Enable experimental dirty schedulers"
  option "with-java", "Build jinterface application"
  option "without-docs", "Do not install documentation"

  deprecated_option "disable-hipe" => "without-hipe"
  deprecated_option "no-docs" => "without-docs"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "fop" => :optional # enables building PDF docs
  depends_on :java => :optional
  depends_on "wxmac" => :recommended # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_21.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_21.0.tar.gz"
    sha256 "10bf0e44b97ee8320c4868d5a4259c49d4d2a74e9c48583735ae0401f010fb31"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_21.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_21.0.tar.gz"
    sha256 "fcc10885e8bf2eef14f7d6e150c34eeccf3fcf29c19e457b4fb8c203e57e153c"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    ENV["FOP"] = "#{HOMEBREW_PREFIX}/bin/fop" if build.with? "fop"

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-threads
      --enable-sctp
      --enable-dynamic-ssl-lib
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --enable-shared-zlib
      --enable-smp-support
    ]

    args << "--enable-darwin-64bit" if MacOS.prefer_64_bit? && OS.mac?
    args << "--enable-native-libs" if build.with? "native-libs"
    args << "--enable-dirty-schedulers" if build.with? "dirty-schedulers"
    args << "--enable-wx" if build.with? "wxmac"
    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed? && OS.mac?
    args << "--enable-kernel-poll" if MacOS.version > :el_capitan

    if build.without? "hipe"
      # HIPE doesn't strike me as that reliable on macOS
      # https://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # https://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << "--disable-hipe"
    else
      args << "--enable-hipe"
    end

    if build.with? "java"
      args << "--with-javac"
    else
      args << "--without-javac"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    if build.with? "docs"
      (lib/"erlang").install resource("man").files("man")
      doc.install resource("html")
    end
  end

  def caveats; <<~EOS
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
  EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
