# fades: Build a bottle for Linux
class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/8b/9c/fd93dff7d8665b704c2f008009876118971df691f8e5bd662befdb8f574c/fades-8.1.tar.gz"
  sha256 "c9ba065b59e9b6a2ab6fb6f65cd71a17e9fc97f543d5c975a4f9841a51d49317"
  revision 1
  head "https://github.com/PyAr/fades.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e7aed83413c92da56871c2b790dd5d7282cf6a5c1b0a868a6f97c6e692f72ff" => :catalina
    sha256 "7e7aed83413c92da56871c2b790dd5d7282cf6a5c1b0a868a6f97c6e692f72ff" => :mojave
    sha256 "7e7aed83413c92da56871c2b790dd5d7282cf6a5c1b0a868a6f97c6e692f72ff" => :high_sierra
    sha256 "f9befb638f4738a2afbe3c26ec631418ebcdc40a50f97947cf19a995547b9067" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system "#{bin}/fades", testpath/"test.py"
  end
end
