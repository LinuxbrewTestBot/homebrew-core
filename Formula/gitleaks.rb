class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v3.2.2.tar.gz"
  sha256 "35734437f206c9452495fe13e5a32012ee418dd58db5355dafacd96ac107e719"

  bottle do
    cellar :any_skip_relocation
    sha256 "6185a5fdfd437544ddac3b6e6f3275e2745138a26e7e06c1d66718574f4da03d" => :catalina
    sha256 "5f6a7908dee8eb4915397783f4698d49c4c094d1d1fdf01dfcb46505e4362de2" => :mojave
    sha256 "bddf3de19485d199251c91c44d671953588a8f1f58d6d1bac2a8cc6a969f4c39" => :high_sierra
    sha256 "548a8bbc80fbf376eccf327dfe4cde63cc5d2c17b8e930e3cddd7e4aa76fc353" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/zricethezav/gitleaks/version.Version=#{version}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"gitleaks"
  end

  test do
    assert_includes shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2), "remote repository is empty"
  end
end
