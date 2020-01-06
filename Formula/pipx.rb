# pipx: Build a bottle for Linux
class Pipx < Formula
  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://github.com/pipxproject/pipx"
  url "https://files.pythonhosted.org/packages/3a/e6/b564df5f299a521bd83d26468a54373fcec3e910b2617e6c6f57f862c9d3/pipx-0.15.0.0.tar.gz"
  sha256 "3393e1cf0eae4e4cb6cb1bbd50402fb187cd494ba858acf85b53bbe60d25589c"
  head "https://github.com/pipxproject/pipx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9d66fcfeab75afb217c37d1886943c390c15fd296e839019fb21d72989d3339" => :catalina
    sha256 "e9d66fcfeab75afb217c37d1886943c390c15fd296e839019fb21d72989d3339" => :mojave
    sha256 "e9d66fcfeab75afb217c37d1886943c390c15fd296e839019fb21d72989d3339" => :high_sierra
    sha256 "c72e9481d326ef5a12c0ffb458ad01b4306998c7e1bac9a6fe0e9fa194310e92" => :x86_64_linux
  end

  depends_on "python"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/9c/c5/4009a381ba46f8424832b6fa9a6d8c79b2089a0170beb434280d293a5b5c/argcomplete-1.10.0.tar.gz"
    sha256 "45836de8cc63d2f6e06b898cef1e4ce1e9907d246ec77ac8e64f23f153d6bec1"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/ca/e3/78443d739d7efeea86cbbe0216511d29b2f5ca8dbf51a6f2898432738987/distro-1.4.0.tar.gz"
    sha256 "362dde65d846d23baee4b5c058c8586f219b5a54be1cf5fc6ff55c4578392f57"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/32/92/4abff0a80d028a306e00bf82f8b21ff18d9ad8199b6d179da3521edf83af/userpath-1.2.0.tar.gz"
    sha256 "10fa2a90c61546f188989680a9b7510888b976f5d18503ad4482c8f919e783cb"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec)
      end
    end

    system "python3", *Language::Python.setup_install_args(libexec)
    (bin/"pipx").write_env_script(libexec/"bin/pipx", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system "#{bin}/pipx", "install", "csvkit"
    assert_true FileTest.exist?("#{testpath}/.local/bin/csvjoin")
    system "#{bin}/pipx", "uninstall", "csvkit"
    assert_no_match Regexp.new("csvjoin"), shell_output("#{bin}/pipx list")
  end
end
