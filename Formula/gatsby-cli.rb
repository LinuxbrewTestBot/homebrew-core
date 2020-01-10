# gatsby-cli: Build a bottle for Linux
require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.26.tgz"
  sha256 "8380d6dfe588621e745ad7f0e63ea7e52244461852fb264d80ae41c67238ffa5"

  bottle do
    cellar :any_skip_relocation
    sha256 "56b15bfc745392cf7aeffd527011a885940a360dec17fb1c94875ef54f2be76a" => :catalina
    sha256 "dbb2bc9322f1e668794bd62b34f30780f73de63ea436d947d3a05617e556740d" => :mojave
    sha256 "18dc3c001939470a3d3d173bd53e9457654f6bf697307175e627011978335b67" => :high_sierra
    sha256 "cce10c05236c58cb3b47c66cc39f527c10a096029aed79f93d5e245b2c414298" => :x86_64_linux
  end

  depends_on "node"
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    if ENV["CI"]
      system "git", "config", "--global", "user.email", "you@example.com"
      system "git", "config", "--global", "user.name", "Your Name"
    end
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
