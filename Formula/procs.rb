class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.5.tar.gz"
  sha256 "d77245acea18ef18308d164f06fa299ddc433bc13006c6d5a9239fee87a4ce21"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2ac131640c53bce4a285749e10bc9493528d4a6df800d80cc3376bce592496f" => :catalina
    sha256 "3fa35891e7014ffc62b3424006a3a84c74240337ef5763aa31b26d8157a2a953" => :mojave
    sha256 "df67246f12cc23c1c21ef8cb51f03107f35ea50e95281e98bedc9f0cc58de21b" => :high_sierra
    sha256 "7dfc2a3f90d322db63d6bf3325b0cd1092ed762bc2afba042d7cba611f4d1c19" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
