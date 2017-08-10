class LinuxHeaders < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.1.43.tar.gz"
  sha256 "11a9234ec51fd98d7148b971cff5864c82d283e484ad9a4516d26f38a8263a82"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "57f09e2f5ef15f7fb75d1bea674ede128f7236d0a497f7eec8fe0988ece9e0d2" => :x86_64_linux
  end

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    assert_match "KERNEL_VERSION", File.read(include/"linux/version.h")
  end
end
