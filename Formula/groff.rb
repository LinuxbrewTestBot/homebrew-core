class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/groff/groff-1.22.4.tar.gz"
  sha256 "e78e7b4cb7dec310849004fa88847c44701e8d133b5d4c13057d876c1bad0293"

  bottle do
    sha256 "a7c425eec2e56f10e06978b393c0cf53269d27f20e801856fd6d2ba91df81136" => :catalina
    sha256 "1ee2ce419f4d59f098f0804e1dea42524ef72a88b69ce891c42f13d5f19be5f9" => :mojave
    sha256 "24fac4b672946970b70c6e308311e87a6686fed50d4d0909228afb252531065d" => :high_sierra
    sha256 "2966f4b562c30eb6679d6940b43f4b99b2b625433e6a218489f160eb76c7c360" => :sierra
    sha256 "d31274339f07f31fa1a710f04120927f11c8ad03d780ddd3e39363ca3a5d5fe3" => :x86_64_linux
  end

  depends_on "texinfo" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    assert_match "homebrew\n",
      pipe_output("#{bin}/groff -a", "homebrew\n")
  end
end
