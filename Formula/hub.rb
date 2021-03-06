class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.14.1.tar.gz"
  sha256 "62c977a3691c3841c8cde4906673a314e76686b04d64cab92f3e01c3d778eb6f"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f092116bb42f4149b0a2abb25ee1752eec32923fe9bd0772607404b3da86e866" => :catalina
    sha256 "671f391bbbd66507a7a9f871ee7222326eb54471478a2e5e1e6122cb58534425" => :mojave
    sha256 "bb9269b14335df7a77cbe8072df072471c980b497c06f33b603744a60fc09d95" => :high_sierra
    sha256 "0d49ec7fa7331c85e89dffec5324b78452b18cd91aac8cd084d32088c4fdb94e" => :x86_64_linux
  end

  depends_on "go" => :build
  unless OS.mac?
    depends_on "util-linux" => :build # for col
    depends_on "groff" => :build
    depends_on "ruby" => :build
  end

  def install
    system "make", "install", "prefix=#{prefix}"

    prefix.install_metafiles

    bash_completion.install "etc/hub.bash_completion.sh"
    zsh_completion.install "etc/hub.zsh_completion" => "_hub"
    fish_completion.install "etc/hub.fish_completion" => "hub.fish"
  end

  test do
    system "git", "init"

    # Test environment has no git configuration, which prevents commiting
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"

    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/hub ls-files").strip
  end
end
