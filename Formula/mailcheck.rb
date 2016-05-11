# mailcheck: Build a bottle for Linuxbrew
class Mailcheck < Formula
  desc "Check multiple mailboxes/maildirs for mail"
  homepage "http://mailcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mailcheck/mailcheck/1.91.2/mailcheck_1.91.2.tar.gz"
  sha256 "6ca6da5c9f8cc2361d4b64226c7d9486ff0962602c321fc85b724babbbfa0a5c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7c134dc23431dfaa3f402b859b7154cab5e176711363bd884dc82ce896d7c7a" => :el_capitan
    sha256 "242b05a6e9b8ccc1ac70e22cbf89bc33a885e726d32509fad6b34a3bee123945" => :yosemite
    sha256 "32b40cf41ec15bcd0efbfb90858534e4b84056915ceacd6914d71d8acdffeb6f" => :mavericks
    sha256 "bf25c7173600f92fb766d88b1a85e8662ced6c32c58410fc08fa519351fa2375" => :x86_64_linux
  end

  def install
    system "make", "mailcheck"
    bin.install "mailcheck"
    man1.install "mailcheck.1"
    etc.install "mailcheckrc"
  end
end
