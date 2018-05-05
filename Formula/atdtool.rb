# atdtool: Build a bottle for Linuxbrew
class Atdtool < Formula
  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://github.com/lpenz/atdtool/archive/upstream/1.3.3.tar.gz"
  sha256 "3e928721388cf6f58b7e663ebc5508f26d180b1c07d5b8119212356c66e57fe8"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1c1b8c7468e0b649ba93da43344eaed88f3e8db4e09bd656398f91b6ebaeef4" => :high_sierra
    sha256 "c1c1b8c7468e0b649ba93da43344eaed88f3e8db4e09bd656398f91b6ebaeef4" => :sierra
    sha256 "c1c1b8c7468e0b649ba93da43344eaed88f3e8db4e09bd656398f91b6ebaeef4" => :el_capitan
    sha256 "1cee126478f50dd0ad7a87237f4ce4577397761d7f33c964c95a14ba6b3178c6" => :x86_64_linux
  end

  depends_on "txt2tags" => :build
  depends_on "python@2"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    prefix.install libexec/"share"
  end

  test do
    system "#{bin}/atdtool", "--help"
  end
end
