class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      :tag      => "v6.8.6",
      :revision => "a174acf677e77d280e3cbbbd8ffb6eca6db80846"
  head "https://github.com/elastic/kibana.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "86aebac6fb40be11009a8d2be5e7904636b338159ae308abc472be375a9dcb45" => :catalina
    sha256 "3149c24c2993d253b00876be56b1b44babeb9ecc96eb2bf55c0bc607641fa4b0" => :mojave
    sha256 "8bcdc16b14a3f940f54384a42086e1e4af5d3f953734c7760131f275ceb32ee5" => :high_sierra
    sha256 "5f1189e79b4a0b50106b93ace2d6e4211f478679c9297506c1337e1fe089743f" => :x86_64_linux
  end

  resource "node" do
    url "https://nodejs.org/dist/v10.15.2/node-v10.15.2.tar.xz"
    sha256 "b8bb2da7cb016e895bc2f70009a420f6b8d519e66548624b6130bbfbd5118c59"
  end

  resource "yarn" do
    url "https://yarnpkg.com/downloads/1.21.1/yarn-v1.21.1.tar.gz"
    sha256 "d1d9f4a0f16f5ed484e814afeb98f39b82d4728c6c8beaafb5abc99c02db6674"
  end

  unless OS.mac?
    depends_on "python@2" => :build
    depends_on "linuxbrew/xorg/libx11"
  end

  def install
    resource("node").stage do
      # Fixes detecting Apple clang 11. (this is the patch that's applied in the node@10 formula)
      inreplace "configure.py" do |s|
        s.gsub! 'cc, r"(^Apple LLVM version) ([0-9]+\.[0-9]+)")', 'cc, r"(^Apple (?:clang|LLVM) version) ([0-9]+\.[0-9]+)")'
      end

      system "./configure", "--prefix=#{libexec}/node"
      system "make", "install"
    end

    # remove non open source files
    rm_rf "x-pack"
    inreplace "package.json", /"x-pack":.*/, ""

    # patch build to not try to read tsconfig.json's from the removed x-pack folder
    inreplace "src/dev/typescript/projects.ts" do |s|
      s.gsub! "new Project(resolve(REPO_ROOT, 'x-pack/tsconfig.json')),", ""
      s.gsub! "new Project(resolve(REPO_ROOT, 'x-pack/test/tsconfig.json'), 'x-pack/test'),", ""
    end

    # trick the build into thinking we've already downloaded the Node.js binary
    mkdir_p buildpath/".node_binaries/#{resource("node").version}/darwin-x64"

    # run yarn against the bundled node version and not our node formula
    (buildpath/"yarn").install resource("yarn")
    (buildpath/".brew_home/.yarnrc").write "build-from-source true\n"
    ENV.prepend_path "PATH", buildpath/"yarn/bin"
    ENV.prepend_path "PATH", prefix/"libexec/node/bin"
    system "yarn", "kbn", "bootstrap"
    system "yarn", "build", "--oss", "--release", "--skip-os-packages", "--skip-archives"

    prefix.install Dir
      .glob("build/oss/kibana-#{version}-darwin-x86_64/**")
      .reject { |f| File.fnmatch("build/oss/kibana-#{version}-darwin-x86_64/{node, data, plugins}", f) }
    mv "licenses/APACHE-LICENSE-2.0.txt", "LICENSE.txt" # install OSS license

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
