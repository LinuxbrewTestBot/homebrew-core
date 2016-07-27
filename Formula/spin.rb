class Spin < Formula
  desc "The efficient verification tool of multi-threaded software"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://spinroot.com/spin/Src/spin645.tar.gz"
  version "6.4.5"
  sha256 "44081282eb63cd9df763ebbcf8bad19dbeefecbebf8ac2cc090ea92e2ab71875"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0dd9b5b6e340f3ccaf22f3825eadadb1de7296c518cc38e4d7ae2e9e0feb09c" => :x86_64_linux
  end

  fails_with :llvm do
    build 2334
  end

  depends_on "bison" => :build unless OS.mac?

  def install
    ENV.deparallelize

    cd "Src#{version}" do
      system "make"
      bin.install "spin"
    end

    bin.install "iSpin/ispin.tcl" => "ispin"
    man1.install "Man/spin.1"
  end

  test do
    (testpath/"test.pml").write <<-EOS.undent
      mtype = { ruby, python };
      mtype = { golang, rust };
      mtype language = ruby;

      active proctype P() {
        do
        :: if
          :: language == ruby -> language = golang
          :: language == python -> language = rust
          fi;
          printf("language is %e", language)
        od
      }
    EOS
    output = shell_output("#{bin}/spin #{testpath}/test.pml")
    assert_match /language is golang/, output
  end
end
