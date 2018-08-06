# ruby-install: Build a bottle for Linuxbrew
class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz"
  sha256 "500a8ac84b8f65455958a02bcefd1ed4bfcaeaa2bb97b8f31e61ded5cd0fd70b"
  head "https://github.com/postmodern/ruby-install.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e88bbe463d29a1e1cc0a91816023346a860a8a08c3daff660c24b313d2b4511" => :high_sierra
    sha256 "0e88bbe463d29a1e1cc0a91816023346a860a8a08c3daff660c24b313d2b4511" => :sierra
    sha256 "0e88bbe463d29a1e1cc0a91816023346a860a8a08c3daff660c24b313d2b4511" => :el_capitan
    sha256 "60043e135e80cc104d8eb04fa14b53c72c6f651d90658d1133e7f7bc81398931" => :x86_64_linux
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
