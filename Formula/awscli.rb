class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.81.tar.gz"
  sha256 "e76f5d6b2a768115322719e29af77957e47a086f0eedfe28206a9392c6bf9150"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "711ee973cdd7f09d371add84f16ff5f4efb44e08c0c239cfaade4e8b8dc4a6fa" => :sierra
    sha256 "5f143a14e41facc77bbd04999d163507659bb0686cec20b31270966a49822fde" => :el_capitan
    sha256 "32875f374951e68bbb3b9240df1cfb91946927e6551b19bf5f3a6c5684a06298" => :yosemite
    sha256 "6177702fdaaaab66ff3570472fb1f2556a2e7a7d11f6c1f84f12d1e4aad1fe52" => :x86_64_linux
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  depends_on "libyaml" unless OS.mac?

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh" => "_aws"
  end

  def caveats; <<-EOS.undent
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
