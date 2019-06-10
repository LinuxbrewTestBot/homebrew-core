# anyenv: Build a bottle for Linuxbrew
class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/v1.1.1.tar.gz"
  sha256 "d7f386f74d5fd40ded51b4e83f05490493fc6b63d22eb3d502836020548b0137"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bc3795db6ae8df4151de4fb15be7122a7c0c416d4bc553976e61b23cb9e3c61" => :mojave
    sha256 "0bc3795db6ae8df4151de4fb15be7122a7c0c416d4bc553976e61b23cb9e3c61" => :high_sierra
    sha256 "c4073892fe99575a1f23eb24714392f098c2980eaaf465a9a8641d955da08306" => :sierra
    sha256 "6428e6a1ef33852c1cfce1c6fca11471fd7575080fb5fae0a8cf33046d7d583a" => :x86_64_linux
  end

  def install
    prefix.install %w[bin completions libexec]
  end

  test do
    Dir.mktmpdir do |dir|
      profile = "#{dir}/.profile"
      File.open(profile, "w") do |f|
        content = <<~EOS
          export ANYENV_ROOT=#{dir}/anyenv
          export ANYENV_DEFINITION_ROOT=#{dir}/anyenv-install
          eval "$(anyenv init -)"
        EOS
        f.write(content)
      end

      cmds = <<~EOS
        anyenv install --force-init
        anyenv install --list
        anyenv install rbenv
        rbenv install --list
      EOS
      cmds.split("\n").each do |cmd|
        shell_output("source #{profile} && #{cmd}")
      end
    end
  end
end
