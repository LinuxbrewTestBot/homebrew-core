require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.22.tgz"
  sha256 "d7f9cbe9d02731d6810693a22eebe142ba6557fd14bba86ce5eea702d3550a68"

  bottle do
    cellar :any_skip_relocation
    sha256 "8caef24e1d6f5f8655107d79c5c15c56b0a5a9997abbc6e5f973a5af7d7f5c70" => :catalina
    sha256 "53572284cb277acf7823bb639e27a21479c5b8d80ff9344b256d640dd6f85372" => :mojave
    sha256 "7ba6fc918c7755e8ab2a21e188cc289ccb6b3c19904258a56e085be0298e5e92" => :high_sierra
    sha256 "c1279f5c227b25a055c42a9b7b87fd514325afc5d711c70edb278f67bb3dc5d0" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match %r{\AInvalid json: [^ ]+\/.ask\/cli_config\Z}, output
    system "#{bin}/ask", "lambda", "--help"
  end
end
