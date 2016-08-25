# gringo: Build a bottle for Linuxbrew
class Gringo < Formula
  desc "Grounder to translate user-provided logic programs"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/gringo/4.5.4/gringo-4.5.4-source.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gringo/gringo_4.5.4.orig.tar.gz"
  sha256 "81f8bbbb1b06236778028e5f1b8627ee38a712ec708724112fb08aecf9bc649a"

  bottle do
    cellar :any_skip_relocation
    sha256 "cae46e44b569bbca76e47a6b87eae77095222fdba020cc702f47eec41561d4e3" => :x86_64_linux
  end

  depends_on "re2c" => :build
  depends_on "scons" => :build
  depends_on "bison" => :build
  depends_on "python" unless OS.mac? # for libpython2.7.so.1.0

  needs :cxx11

  def install
    # Allow pre-10.9 clangs to build in C++11 mode
    ENV.libcxx

    inreplace "SConstruct",
              "env['CXX']            = 'g++'",
              "env['CXX']            = '#{ENV.cxx}'"

    scons "--build-dir=release", "gringo", "clingo", "reify"
    bin.install "build/release/gringo", "build/release/clingo", "build/release/reify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gringo --version")
  end
end
