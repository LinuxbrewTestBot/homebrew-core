# lftp: Build a bottle for Linuxbrew
class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.4.tar.xz"
  sha256 "4ebc271e9e5cea84a683375a0f7e91086e5dac90c5d51bb3f169f75386107a62"
  revision 2

  bottle do
    sha256 "6861fecd8432bb8877144bf61df25f052509d1ffd692b9f72e2bb9d86b542750" => :mojave
    sha256 "b45767d676b23b29eab6b820057820adcac582304ea44ac7926060407c63d072" => :sierra
    sha256 "ef7a38c92207b275c1b6077e97e81fbe83c8ab8a0d3092e57765b1e7b183fae3" => :x86_64_linux
  end

  depends_on "libidn"
  depends_on "openssl@1.1"
  depends_on "readline"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn=#{Formula["libidn"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open https://ftp.gnu.org/; ls"
  end
end
