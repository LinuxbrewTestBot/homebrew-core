# hub: Build a bottle for Linuxbrew
class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.5.1.tar.gz"
  sha256 "35fecdbcaf0afb6b7273a160cc169f76ec62b95105037ac3fc833b24573f9a4f"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "615f3b7b09e7ea0cb5cd4de1ecf5a1ad5f61382860524624ecccaffffd4c818d" => :high_sierra
    sha256 "8e191a21ad7b1cb2bb746257d99f322b7169879fe4f42f6619234c6abfb552ef" => :sierra
    sha256 "2e59d1b0a83718d1663a40c895fb3a6d6faf9f12cf0519f4c0a9105c2c30f4cd" => :el_capitan
    sha256 "af9ded7ac23a11c6832812d1d40eeb67b4811e7509b30f00019a8e3665c25079" => :x86_64_linux
  end

  option "without-completions", "Disable bash/zsh completions"
  option "without-docs", "Don't install man pages"

  depends_on "go" => :build

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

  if !OS.mac? && build.with?("docs")
    depends_on "bsdmainutils" => :build
    depends_on "groff" => :build
    depends_on "ruby" => :build
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/hub").install buildpath.children
    cd "src/github.com/github/hub" do
      if build.with? "docs"
        begin
          deleted = ENV.delete "SDKROOT"
          ENV["GEM_HOME"] = buildpath/"gem_home"
          system "gem", "install", "bundler"
          ENV.prepend_path "PATH", buildpath/"gem_home/bin"
          system "make", "man-pages"
        ensure
          ENV["SDKROOT"] = deleted
        end
        system "make", "install", "prefix=#{prefix}"
      else
        system "script/build", "-o", "hub"
        bin.install "hub"
      end

      prefix.install_metafiles

      if build.with? "completions"
        bash_completion.install "etc/hub.bash_completion.sh"
        zsh_completion.install "etc/hub.zsh_completion" => "_hub"
        fish_completion.install "etc/hub.fish_completion" => "hub.fish"
      end
    end
  end

  test do
    system "git", "init"

    # Test environment has no git configuration, which prevents commiting
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"

    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/hub ls-files").strip
  end
end
