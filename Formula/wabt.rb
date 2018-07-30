# wabt: Build a bottle for Linuxbrew
class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt/archive/1.0.2.tar.gz"
  sha256 "81cfb3d6f679e07be0b57a9cc8fbb44a357f286a40ceefa03912c0988809e495"

  bottle do
    cellar :any_skip_relocation
    sha256 "5465305c722c45351b3f5b883c4fba1789f14316dd2e34bee34ab913b0ba2125" => :high_sierra
    sha256 "9d196438eeb0a45d26ebb080d9f3fe0d3b13662d30f0167ba12f8db2debac15c" => :sierra
    sha256 "0f4ff53ff017c470baa1ab2f97d201a73d423e02289a3a20b5e990bc1c7def20" => :el_capitan
    sha256 "416053a02559158f6c0e26ab8a4e4578fc11afad8551451e4c338917d6a5287e" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "python@2" => :build unless OS.mac?

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end
