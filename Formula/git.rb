# git: Build a bottle for Linuxbrew
class Git < Formula
  desc "Distributed revision control system"
  homepage "https://git-scm.com"
  url "https://www.kernel.org/pub/software/scm/git/git-2.19.1.tar.xz"
  sha256 "345056aa9b8084280b1b9fe1374d232dec05a34e8849028a20bfdb56e920dbb5"
  head "https://github.com/git/git.git", :shallow => false

  bottle do
    sha256 "003dd1860023d20655740cc5ca1e2699910bd99d824d530a3b8f29d91f02dd42" => :mojave
    sha256 "20a44d52c512481f0b56f3280e9dcf6b2ec6d6935b6fbd0a6f6dc346b07807b5" => :high_sierra
    sha256 "debff9bff0889579d54bdd69c630bdafbced59ae44534dddeb04e9d5b8599f54" => :sierra
  end

  depends_on "gettext"
  depends_on "pcre2"

  if OS.mac?
    if MacOS.version < :yosemite
      depends_on "openssl"
      depends_on "curl"
    else
      deprecated_option "with-brewed-openssl" => "with-openssl"
      deprecated_option "with-brewed-curl" => "with-curl"

      option "with-openssl", "Build with Homebrew's OpenSSL instead of using CommonCrypto"
      option "with-curl", "Use Homebrew's version of cURL library"

      depends_on "openssl" => :optional
      depends_on "curl" => :optional
    end
  end

  unless OS.mac?
    depends_on "curl"
    depends_on "expat"
    depends_on "openssl"
    depends_on "tcl-tk" => :optional
    depends_on "zlib"
  end

  resource "html" do
    url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.19.1.tar.xz"
    sha256 "7252eb32735ca60f86d0a2081891c8cc5937a2e03373c92e8eaf657029776482"
  end

  resource "man" do
    url "https://www.kernel.org/pub/software/scm/git/git-manpages-2.19.1.tar.xz"
    sha256 "27af909c7a43ffc8b1736af19a6a68d8a5b177963ec4ddd2b2f9f0ed53bcc6ee"
  end

  def install
    # If these things are installed, tell Git build system not to use them
    ENV["NO_FINK"] = "1"
    ENV["NO_DARWIN_PORTS"] = "1"
    ENV["NO_R_TO_GCC_LINKER"] = "1" # pass arguments to LD correctly
    ENV["PYTHON_PATH"] = which("python")
    ENV["PERL_PATH"] = which("perl")
    ENV["USE_LIBPCRE2"] = "1"
    ENV["INSTALL_SYMLINKS"] = "1"
    ENV["LIBPCREDIR"] = Formula["pcre2"].opt_prefix
    ENV["V"] = "1" # build verbosely

    perl_version = Utils.popen_read("perl --version")[/v(\d+\.\d+)(?:\.\d+)?/, 1]

    if MacOS.version >= :mavericks
      ENV["PERLLIB_EXTRA"] = %W[
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      ].uniq.map do |p|
        "#{p}/Library/Perl/#{perl_version}/darwin-thread-multi-2level"
      end.join(":")
    end

    unless quiet_system ENV["PERL_PATH"], "-e", "use ExtUtils::MakeMaker"
      ENV["NO_PERL_MAKEMAKER"] = "1"
    end

    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
    ]
    args << "NO_TCLTK=1" if build.without? "tcl-tk"

    if build.with?("openssl") || MacOS.version < :yosemite
      openssl_prefix = Formula["openssl"].opt_prefix
      args += %W[NO_APPLE_COMMON_CRYPTO=1 OPENSSLDIR=#{openssl_prefix}]
    else
      args += %w[NO_OPENSSL=1 APPLE_COMMON_CRYPTO=1]
    end

    system "make", "install", *args

    git_core = libexec/"git-core"

    # Install the macOS keychain credential helper
    cd "contrib/credential/osxkeychain" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      git_core.install "git-credential-osxkeychain"
      system "make", "clean"
    end if OS.mac?

    # Generate diff-highlight perl script executable
    cd "contrib/diff-highlight" do
      system "make"
    end

    # Install the netrc credential helper
    cd "contrib/credential/netrc" do
      system "make", "test"
      git_core.install "git-credential-netrc"
    end

    # Install git-subtree
    cd "contrib/subtree" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      git_core.install "git-subtree"
    end

    # install the completion script first because it is inside "contrib"
    bash_completion.install "contrib/completion/git-completion.bash"
    bash_completion.install "contrib/completion/git-prompt.sh"
    zsh_completion.install "contrib/completion/git-completion.zsh" => "_git"
    cp "#{bash_completion}/git-completion.bash", zsh_completion

    elisp.install Dir["contrib/emacs/*.el"]
    (share/"git-core").install "contrib"

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource("man")
    (share/"doc/git-doc").install resource("html")

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]

    # To avoid this feature hooking into the system OpenSSL, remove it.
    # If you need it, install git --with-openssl.
    if MacOS.version >= :yosemite && build.without?("openssl")
      rm "#{libexec}/git-core/git-imap-send"
    end

    # This is only created when building against system Perl, but it isn't
    # purged by Homebrew's post-install cleaner because that doesn't check
    # "Library" directories. It is however pointless to keep around as it
    # only contains the perllocal.pod installation file.
    rm_rf prefix/"Library/Perl"

    pod = Dir[lib/"*/*/perllocal.pod"][0]
    unless pod.nil?
      # Remove perllocal.pod, which conflicts with the perl formula.
      # I don't know why this issue doesn't affect Mac.
      rm_r Pathname.new(pod).dirname.dirname
    end

    # Set the macOS keychain credential helper by default
    # (as Apple's CLT's git also does this).
    (buildpath/"gitconfig").write <<~EOS
      [credential]
      \thelper = osxkeychain
    EOS
    etc.install "gitconfig" if OS.mac?
  end

  test do
    system bin/"git", "init"
    %w[haunted house].each { |f| touch testpath/f }

    # Test environment has no git configuration, which prevents commiting
    system bin/"git", "config", "user.email", "you@example.com"
    system bin/"git", "config", "user.name", "Your Name"

    system bin/"git", "add", "haunted", "house"
    system bin/"git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/git ls-files").strip
  end
end
