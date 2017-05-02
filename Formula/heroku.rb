class Heroku < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://cli.heroku.com"
  if OS.mac?
    url "https://cli-assets.heroku.com/branches/stable/5.9.0-1b8deac/heroku-v5.9.0-1b8deac-darwin-amd64.tar.xz"
    sha256 "37a578261bad805788a24acbb76cf70adef258b5ee4d75894af3691dcc73f02e"
  elsif OS.linux?
    url "https://cli-assets.heroku.com/branches/stable/5.9.0-1b8deac/heroku-v5.9.0-1b8deac-linux-amd64.tar.xz"
    sha256 "4ec4a01bb7a3e401e7ed7036d34a8a5c83d12ab2195f8db3b03c4aca9f9af97b"
  end
  version "5.9.0"

  bottle :unneeded

  depends_on :arch => :x86_64

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/heroku"
  end

  test do
    system bin/"heroku", "version"
  end
end
