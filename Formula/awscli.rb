# awscli: Build a bottle for Linuxbrew
class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.16.170.tar.gz"
  sha256 "5d578e41bfe5c43c6107f56506d6f6543349728c3f3168d098f5fb5939ebcab7"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "4148adad96f53c731a24cfbfc8b0400e50ea63501cf99ed76fe66f23b82e49fc" => :mojave
    sha256 "8a4b0f32cca2f048803361e47bf19d5c57ad8eb854689aa40c657e3d9f7b7891" => :high_sierra
    sha256 "b924ba2baa54f73dd4332ab18326f39de737a0258761fc46d00bc5b6bfa74461" => :sierra
    sha256 "ea2a5e56f770ad067647e2b0fe8efe5b9e899c7bc8047aa9fc085044119cfb45" => :x86_64_linux
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python"

  depends_on "libyaml" unless OS.mac?

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats; <<~EOS
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
  EOS
  end

  test do
    if OS.mac?
      assert_match "topics", shell_output("#{bin}/aws help")
    else
      # aws-cli needs groff as dependency, which we do not want to install
      # just to display the help.
      system "#{bin}/aws", "--version"
    end
  end
end
