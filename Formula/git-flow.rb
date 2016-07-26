# git-flow: Build a bottle for Linuxbrew
class GitFlow < Formula
  desc "Extensions to follow Vincent Driessen's branching model"
  homepage "https://github.com/nvie/gitflow"

  stable do
    # Use the tag instead of the tarball to get submodules
    url "https://github.com/nvie/gitflow.git",
      :tag => "0.4.1",
      :revision => "1ffb6b1091f05466d3cd27f2da9c532a38586ed5"

    resource "completion" do
      url "https://github.com/bobthecow/git-flow-completion/archive/0.4.2.2.tar.gz"
      sha256 "1e82d039596c0e73bfc8c59d945ded34e4fce777d9b9bb45c3586ee539048ab9"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8cfaa3b611d5356dd4016366a2b3579f259edc8ad3969b5c68cffe76709e4de0" => :x86_64_linux
  end

  head do
    url "https://github.com/nvie/gitflow.git", :branch => "develop"

    resource "completion" do
      url "https://github.com/bobthecow/git-flow-completion.git", :branch => "develop"
    end
  end

  conflicts_with "git-flow-avh"

  def install
    system "make", "prefix=#{libexec}", "install"
    bin.write_exec_script libexec/"bin/git-flow"

    resource("completion").stage do
      bash_completion.install "git-flow-completion.bash"
      zsh_completion.install "git-flow-completion.zsh"
    end
  end

  test do
    system "git", "flow", "init", "-d"
    assert_equal "develop", shell_output("git rev-parse --abbrev-ref HEAD").strip
  end
end
