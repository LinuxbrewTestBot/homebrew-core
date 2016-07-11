# github-markdown-toc: Build a bottle for Linuxbrew
require "language/go"

class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/0.6.0.tar.gz"
  sha256 "fe6995e9f06febca0f3a68d0df5f124726737bcfbcc027dce4aa9d5dfa1ee5ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "a104f53c052b50fdef8491bc268c8251e635eb106caa500defe778fe2d3e2a69" => :x86_64_linux
  end

  depends_on "go" => :build

  go_resource "github.com/alecthomas/template" do
    url "https://github.com/alecthomas/template.git",
      :revision => "14fd436dd20c3cc65242a9f396b61bfc8a3926fc"
  end

  go_resource "github.com/alecthomas/units" do
    url "https://github.com/alecthomas/units.git",
      :revision => "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://github.com/alecthomas/kingpin.git",
      :revision => "v2.1.11"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/ekalinin/"
    ln_sf buildpath, buildpath/"src/github.com/ekalinin/github-markdown-toc.go"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "gh-md-toc", "main.go"
    bin.install "gh-md-toc"
  end

  test do
    system bin/"gh-md-toc", "--version"
    system bin/"gh-md-toc", "../README.md"
  end
end
