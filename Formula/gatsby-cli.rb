# gatsby-cli: Build a bottle for Linux
require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.19.tgz"
  sha256 "a0e7ab76a903700d4adb5b48206f8f46600a3c855d0ee6c0bbec2ef99651c060"

  bottle do
    cellar :any_skip_relocation
    sha256 "7179314abd5acad8ad1028fd8043a1597a8a9e5f7fa2d89e1b89ebe44c858fb2" => :catalina
    sha256 "f04132fe7cc856cb300534e15b2e14bb910aebba67de9de56df00418b27ba872" => :mojave
    sha256 "df9df45717dae4aa1389df47a7c140b1290dcf31e18090a08d3797ad016f5758" => :high_sierra
    sha256 "1d22b556483dc9b000454f3beafc6da53281530a80b64b82a2614ba25587cd3a" => :x86_64_linux
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
