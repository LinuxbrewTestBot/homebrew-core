class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.1.tar.gz"
  sha256 "c7cb465ff97c46ad48f32a2ad5baa5a61a076eaa0faf6d5d4e44ae5aa38494b2"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "95cec024e6ace171b3a7ea88487ed7cb614e3d7db7cf47cbdd8e4875888f7485" => :catalina
    sha256 "635691a03bd533c59c42b8b9e11af652d2c582179098ff422df409fff5c5d96d" => :mojave
    sha256 "15c494f50d4b770451b4205fc17e477a74300252df72dd0520c94f49d8e012af" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build] if OS.mac?
  depends_on :macos

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
