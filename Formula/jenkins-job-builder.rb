class JenkinsJobBuilder < Formula
  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "https://docs.openstack.org/infra/jenkins-job-builder/"
  url "https://files.pythonhosted.org/packages/8c/5b/e0bffbf54967d6ca3a996a23798de9a2eac68b604b5ed1c841b47188851e/jenkins-job-builder-3.2.0.tar.gz"
  sha256 "11cae061b157e41ab4bdbb82c56455dccc0bace009648af3bb4ca4360ae75dda"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2971284bddb5b14e31c66582def5ad456252cf1816efffda347c7c815bf11a9" => :catalina
    sha256 "68599ee49146eb3acfddebf29cca58c2616a1756e6b6f0e4cdeb025b58e49670" => :mojave
    sha256 "d4c8ffd83340a9a18889442002dbd7626420ca9911d835bda2ca5c6a2f635cff" => :high_sierra
    sha256 "86c3ef061e7292552754125ca5b6531326af6d34ca6883b521ad9198967e63af" => :x86_64_linux
  end

  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e1/0f/f8d5e939184547b3bdc6128551b831a62832713aa98c2ccdf8c47ecc7f17/certifi-2018.8.24.tar.gz"
    sha256 "376690d6f16d32f9d1fe8932551d80b23e9d393a8578c5633a2ed39a64861638"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/f4/6f/41b835c9bf69b03615630f8a6f6d45dafbec95eb4e2bb816638f043552b2/fasteners-0.14.1.tar.gz"
    sha256 "427c76773fe036ddfa41e57d89086ea03111bbac57c55fc55f3006d027107e18"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/19/c1/27f722aaaaf98786a1b338b78cf60960d9fe4849825b071f4e300da29589/monotonic-1.5.tar.gz"
    sha256 "23953d55076df038541e648a53676fb24980f7a1be290cdda21300b3bc21dfb0"
  end

  resource "multi_key_dict" do
    url "https://files.pythonhosted.org/packages/6d/97/2e9c47ca1bbde6f09cb18feb887d5102e8eacd82fbc397c77b221f27a2ab/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c8/c3/935b102539529ea9e6dcf3e8b899583095a018b09f29855ab754a2012513/pbr-4.2.0.tar.gz"
    sha256 "1b8be50d938c9bb75d0eaf7eda111eec1bf6dc88a62a6412e33bf077457e0f45"
  end

  resource "python-jenkins" do
    url "https://files.pythonhosted.org/packages/4d/2e/58ab460a6bc77b25823e9acc82c38bbde7c26ada7f627500d8cb7f68861e/python-jenkins-1.2.1.tar.gz"
    sha256 "62114d830cc95dee9d9a75f5c4e0fd2ea7b0ca17b0f09357a01a22432c09d325"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"
    sha256 "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/61/c9/1d10fc4ffd9657caea9e3f0428cad6e0eefed9dfea11435f97ab34c1927f/stevedore-1.29.0.tar.gz"
    sha256 "1e153545aca7a6a49d8337acca4f41c212fbfa60bf864ecd056df0cafb9627e8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |resource|
      resource.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "usage", shell_output("#{bin}/jenkins-jobs --help")

    # The following test requires that Jenkins is configured on this host.
    return unless OS.mac?

    assert_match("Managed by Jenkins Job Builder",
                 pipe_output("#{bin}/jenkins-jobs test /dev/stdin",
                             "- job:\n    name: test-job\n\n", 0))
  end
end
