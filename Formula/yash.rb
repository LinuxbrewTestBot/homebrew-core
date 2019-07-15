# yash: Build a bottle for Linuxbrew
class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/70439/yash-2.48.tar.xz"
  sha256 "f46294d77c5a646405db20a6dc3d16bc1ed109b061b2a508081ce483153c1e8d"

  bottle do
    sha256 "78fbbc947f0cbe7484acc442be951dd47941358220bc4abf75f2e466b746efde" => :mojave
    sha256 "ff5e85274a16fedb468c62ce09866ca475f6c651f0fd139b46847e07f4c120a6" => :high_sierra
    sha256 "29e2875a5ea150b0517006280265ed2a11da8cb9c050b1b1c34777f2a90b3e22" => :sierra
    sha256 "1bcb67c40c06172e6f5e3e2e91fe83d3e6796d44b4ad01ada641dedd80178575" => :x86_64_linux
  end

  depends_on "gettext"

  def install
    system "sh", "./configure",
            "--prefix=#{prefix}",
            "--enable-array",
            "--enable-dirstack",
            "--enable-help",
            "--enable-history",
            "--enable-lineedit",
            "--enable-nls",
            "--enable-printf",
            "--enable-socket",
            "--enable-test",
            "--enable-ulimit"
    system "make", "install"
  end

  test do
    system "#{bin}/yash", "-c", "echo hello world"
  end
end
