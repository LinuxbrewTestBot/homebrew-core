# es: Build a bottle for Linuxbrew
class Es < Formula
  desc "Extensible shell with first class functions, lexical scoping, and more"
  homepage "https://wryun.github.io/es-shell/"
  url "https://github.com/wryun/es-shell/releases/download/v0.9.1/es-0.9.1.tar.gz"
  sha256 "b0b41fce99b122a173a06b899a4d92e5bd3cc48b227b2736159f596a58fff4ba"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "47eb9c54542fdc1f05144632e4d0cb93a50d8ddea973d452b98ad4de527b2d25" => :x86_64_linux
  end

  option "with-readline", "Use readline instead of libedit"

  depends_on "readline" => :optional

  conflicts_with "kes", :because => "both install 'es' binary"

  def install
    args = %W[--prefix=#{prefix}]

    if build.with? "readline"
      args << "--with-readline"
    else
      args << "--with-editline"
    end

    system "./configure", *args
    system "make"

    man1.install "doc/es.1"
    bin.install "es"
    doc.install %w[CHANGES README trip.es examples]
  end

  test do
    system "#{bin}/es < #{doc}/trip.es"
  end
end
