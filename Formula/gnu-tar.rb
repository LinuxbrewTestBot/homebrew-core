class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "https://ftp.gnu.org/gnu/tar/tar-1.32.tar.gz"
  mirror "https://ftpmirror.gnu.org/tar/tar-1.32.tar.gz"
  sha256 "b59549594d91d84ee00c99cf2541a3330fed3a42c440503326dab767f2fbb96c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    sha256 "62ef2c92bf090b1ada1b8434034be21ac4534e9ab81388516191b7cecd6c095a" => :mojave
    sha256 "440e9a400c184e76bff84b0b634b1a103231409735c4f7885404d9619ca96c43" => :high_sierra
    sha256 "d245b143eae5179554fca39cdaf37e928e85df8956087d43c5ec0ac968f6c0e8" => :sierra
    sha256 "d70d10d0ba6ccd6181b52965e4b5df9d417c32b85a4a889581f797cf96623a94" => :x86_64_linux
  end

  head do
    url "https://git.savannah.gnu.org/git/tar.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # https://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    ENV["gl_cv_func_getcwd_abort_bug"] = "no" if MacOS.version == :el_capitan

    # Fix configure: error: you should not run configure as root
    ENV["FORCE_UNSAFE_CONFIGURE"] = "1" unless ENV["CIRCLECI"]

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      # Symlink the executable into libexec/gnubin as "tar"
      (libexec/"gnubin").install_symlink bin/"gtar" =>"tar"
      (libexec/"gnuman/man1").install_symlink man1/"gtar.1" => "tar.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    return unless OS.mac?
    <<~EOS
      GNU "tar" has been installed as "gtar".
      If you need to use it as "tar", you can add a "gnubin" directory
      to your PATH from your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    (testpath/"test").write("test")
    if OS.mac?
      system bin/"gtar", "-czvf", "test.tar.gz", "test"
      assert_match /test/, shell_output("#{bin}/gtar -xOzf test.tar.gz")
      assert_match /test/, shell_output("#{opt_libexec}/gnubin/tar -xOzf test.tar.gz")
    end

    unless OS.mac?
      system bin/"tar", "-czvf", "test.tar.gz", "test"
      assert_match /test/, shell_output("#{bin}/tar -xOzf test.tar.gz")
    end
  end
end
