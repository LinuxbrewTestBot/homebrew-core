require "language/node"

class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      :tag => "v6.1.2",
      :revision => "664614f2474b23d543088b530df9ae2a3c9f4516"
  head "https://github.com/elastic/kibana.git"
  revision 1 unless OS.mac?

  bottle do
    sha256 "e29ff7b51c997a5a4bc18fecd7410c1935f9ead986766d708b3a3387a4bc4e6e" => :high_sierra
    sha256 "f11a4e416834bad6245ac6152359a0fb4a4e8c15d7dd66cdd0a86591a17a91fb" => :sierra
    sha256 "e3f59178499b7649834c259a83beac6489766ee3f73045935ea8fa7ee38ceeed" => :el_capitan
  end

  resource "node" do
    url "https://github.com/nodejs/node.git",
        :tag => "v6.12.2",
        :revision => "381f5ec383dbb164cf3edd1a9de1811cf1cfdc65"
  end

  depends_on "python" => :build unless OS.mac?

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    resource("node").stage do
      system "./configure", "--prefix=#{libexec}/node"
      system "make", "install"
    end

    # do not build packages for other platforms
    inreplace buildpath/"tasks/config/platforms.js", /('(linux-x64|windows-x64)',?(?!;))/, "// \\1"

    # trick the build into thinking we've already downloaded the Node.js binary
    mkdir_p buildpath/".node_binaries/#{resource("node").version}/darwin-x64"

    # set npm env and fix cache edge case (https://github.com/Homebrew/brew/pull/37#issuecomment-208840366)
    ENV.prepend_path "PATH", prefix/"libexec/node/bin"
    system "npm", "install", "-ddd", "--build-from-source", "--#{Language::Node.npm_cache_config}"
    system "npm", "run", "build", "--", "--release", "--skip-os-packages", "--skip-archives"

    prefix.install Dir["build/kibana-#{version}-darwin-x86_64/{bin,config,node_modules,optimize,package.json,src,ui_framework,webpackShims}"]

    inreplace "#{bin}/kibana", %r{/node/bin/node}, "/libexec/node/bin/node"
    inreplace "#{bin}/kibana-plugin", %r{/node/bin/node}, "/libexec/node/bin/node"

    cd prefix do
      inreplace "config/kibana.yml", "/var/run/kibana.pid", var/"run/kibana.pid"
      (etc/"kibana").install Dir["config/*"]
      rm_rf "config"
    end
  end

  def post_install
    ln_s etc/"kibana", prefix/"config"
    (prefix/"data").mkdir
    (prefix/"plugins").mkdir
  end

  def caveats; <<~EOS
    Config: #{etc}/kibana/
    If you wish to preserve your plugins upon upgrade, make a copy of
    #{opt_prefix}/plugins before upgrading, and copy it into the
    new keg location after upgrading.
    EOS
  end

  plist_options :manual => "kibana"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/kibana</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"
    assert_match /#{version}/, shell_output("#{bin}/kibana -V")
  end
end
