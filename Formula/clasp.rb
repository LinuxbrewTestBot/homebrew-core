class Clasp < Formula
  desc "Answer set solver for (extended) normal logic programs"
  homepage "https://potassco.org/clasp/"
  url "https://github.com/potassco/clasp/archive/v3.3.2.tar.gz"
  sha256 "367f9f3f035308bd32d5177391a470d9805efc85a737c4f4d6d7b23ea241dfdf"

  bottle do
    cellar :any_skip_relocation
    sha256 "60ffdb9f97e1318efd58b5cbb6c6ea401c94c79e2229c3e4980da61eca81a838" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clasp --version")
  end
end
