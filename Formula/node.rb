# node: Build a bottle for Linuxbrew
class Node < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v8.7.0/node-v8.7.0.tar.xz"
  sha256 "5a17d08c68ee7c1e748fd32534edda766cb57c13ed98e693f3075bc9d9a0b59a"
  head "https://github.com/nodejs/node.git"

  bottle do
    sha256 "7623c96129d70516cff0a903f57ae2c3637c19ce10b08a4575f593748701a1ac" => :high_sierra
    sha256 "3b432845ee199a1473e7d17ef3f52468c24cc4ae6b18392a66626487c17f86a6" => :sierra
    sha256 "8ef033fd111cf4cb953e768ff033ad92340f7333c2f95e404f2cd286480b5778" => :el_capitan
    sha256 "31297ac74b50cb0f585b728e0c53ca7b00ae78214606f7b4812d78615bf4f4d1" => :x86_64_linux
  end

  option "with-debug", "Build with debugger hooks"
  option "with-openssl", "Build against Homebrew's OpenSSL instead of the bundled OpenSSL"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"
  option "without-icu4c", "Build with small-icu (English only) instead of system-icu (all locales)"

  deprecated_option "enable-debug" => "with-debug"

  if OS.mac?
    depends_on :python => :build if MacOS.version <= :snow_leopard
  else
    # Needed at runtime (for the tests on Linux for example)
    depends_on :python
  end
  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "openssl" => :optional

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
  end

  # We track major/minor from upstream Node releases.
  # We will accept *important* npm patch releases when necessary.
  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-5.4.2.tgz"
    sha256 "04dc5f87b1079d59d51404d4b4c4aacbe385807a33bd15a8f2da2fabe27bf443"
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    # Never install the bundled "npm", always prefer our
    # installation from tarball for better packaging control.
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--with-intl=system-icu" if build.with? "icu4c"
    args << "--shared-openssl" if build.with? "openssl"
    args << "--tag=head" if build.head?

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      # Allow npm to find Node before installation has completed.
      ENV.prepend_path "PATH", bin

      bootstrap = buildpath/"npm_bootstrap"
      bootstrap.install resource("npm")
      system "node", bootstrap/"bin/npm-cli.js", "install", "-ddd", "--global",
             "--prefix=#{libexec}", resource("npm").cached_download

      # Fix from chrmoritz for ENOENT issue with @ in path to node
      inreplace libexec/"lib/node_modules/npm/node_modules/libnpx/index.js",
                "return child.escapeArg(npmPath, true)", "return npmPath"

      # The `package.json` stores integrity information about the above passed
      # in `cached_download` npm resource, which breaks `npm -g outdated npm`.
      # This copies back over the vanilla `package.json` to fix this issue.
      cp bootstrap/"package.json", libexec/"lib/node_modules/npm"
      # These symlinks are never used & they've caused issues in the past.
      rm_rf libexec/"share"

      if build.with? "completion"
        bash_completion.install \
          bootstrap/"lib/utils/completion.sh" => "npm"
      end
    end
  end

  def post_install
    return if build.without? "npm"

    node_modules = HOMEBREW_PREFIX/"lib/node_modules"
    node_modules.mkpath
    # Kill npm but preserve all other modules across node updates/upgrades.
    rm_rf node_modules/"npm"

    cp_r libexec/"lib/node_modules/npm", node_modules
    # This symlink doesn't hop into homebrew_prefix/bin automatically so
    # we make our own. This is a small consequence of our
    # bottle-npm-and-retain-a-private-copy-in-libexec setup
    # All other installs **do** symlink to homebrew_prefix/bin correctly.
    # We ln rather than cp this because doing so mimics npm's normal install.
    ln_sf node_modules/"npm/bin/npm-cli.js", HOMEBREW_PREFIX/"bin/npm"
    ln_sf node_modules/"npm/bin/npx-cli.js", HOMEBREW_PREFIX/"bin/npx"

    # Let's do the manpage dance. It's just a jump to the left.
    # And then a step to the right, with your hand on rm_f.
    %w[man1 man5 man7].each do |man|
      # Dirs must exist first: https://github.com/Homebrew/legacy-homebrew/issues/35969
      mkdir_p HOMEBREW_PREFIX/"share/man/#{man}"
      rm_f Dir[HOMEBREW_PREFIX/"share/man/#{man}/{npm.,npm-,npmrc.,package.json.,npx.}*"]
      cp Dir[libexec/"lib/node_modules/npm/man/#{man}/{npm,package.json,npx}*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    npm_root = node_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    if build.without? "npm"
      <<-EOS.undent
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output
    if build.with? "icu4c"
      output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
      assert_equal "1.234,56", output
    end

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      ENV.delete "NVM_NODEJS_ORG_MIRROR"
      assert_equal which("node"), opt_bin/"node"
      assert_predicate HOMEBREW_PREFIX/"bin/npm", :exist?, "npm must exist"
      assert_predicate HOMEBREW_PREFIX/"bin/npm", :executable?, "npm must be executable"
      npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
      system "#{HOMEBREW_PREFIX}/bin/npm", *npm_args, "install", "npm@latest"
      system "#{HOMEBREW_PREFIX}/bin/npm", *npm_args, "install", "bignum" unless head?
      assert_predicate HOMEBREW_PREFIX/"bin/npx", :exist?, "npx must exist"
      assert_predicate HOMEBREW_PREFIX/"bin/npx", :executable?, "npx must be executable"
      assert_match "< hello >", shell_output("#{HOMEBREW_PREFIX}/bin/npx --cache=#{HOMEBREW_CACHE}/npm_cache cowsay hello")
    end
  end
end
