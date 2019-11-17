# lazydocker: Build a bottle for Linux
class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      :tag      => "v0.7.6",
      :revision => "450d16304087f16da0f9ce15b54640599cb163d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "e67ef3109ad1a907b47b13b21b618a6f689c054e5ca77b731517d2fc28b22d29" => :catalina
    sha256 "2f9240f41656d68cc0334c4bf8b5d3c960de18d504a32ef5f019eeff4a0b99fc" => :mojave
    sha256 "50094916596e0bc7eb2b377ee80f5f474970b4b2bdbae2693c005860df994584" => :high_sierra
    sha256 "ac1f4a4276a7d504d6bb8dda415d13b7996eb590ed02ee92a3ad51a4da458c78" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "reporting: undetermined", shell_output("#{bin}/lazydocker --config")
  end
end
