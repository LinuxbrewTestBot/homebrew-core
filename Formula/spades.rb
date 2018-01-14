# spades: Build a bottle for Linuxbrew
class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1.tar.gz"
  sha256 "3ab85d86bf7d595bd8adf11c971f5d258bbbd2574b7c1703b16d6639a725b474"
  revision 2

  bottle do
    cellar :any
    sha256 "ac5ba28bf8f5a036fef692e9bac49b0a639498a8cad6a147a60278718d7e2dd5" => :high_sierra
    sha256 "d76f3eaab06132b2abc7111cc0bddb28b83c5bd587838f369059511887d9fe00" => :sierra
    sha256 "b987897ae0e825ef61471d32a210fadfe54abf3aa8a785d64699d0f123971537" => :el_capitan
    sha256 "244b706e9d5d3a6dc876b656c4d2ad8981ceb82d9fa13865f5e9c15a9c1fe1f5" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "python" if MacOS.version <= :snow_leopard

  fails_with :clang # no OpenMP support

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j2" if ENV["CIRCLECI"]

    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
