class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.12.20.tar.gz"
  sha256 "05415371bee3e00642c8ec93ab3183f7f3e60f33b8d345ba25173668ca41bab1"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25c7620a0343e13244b141db9aea321b296eaf9ad5abcf20a89db966d280ac35" => :catalina
    sha256 "f5b3312733631a42e9067032cef62803e500a2465e6cd979841b597a6ed4fed7" => :mojave
    sha256 "94c079fbac973d6507838d4e7f9b7a0be31421877f7662fd0db43d06b10f046e" => :high_sierra
    sha256 "249a460ee1d835866f49191116b7a7beb07e1d50c4bb305fcf921e8f1d93918d" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  conflicts_with "tfenv", :because => "tfenv symlinks terraform binaries"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on" unless OS.mac?
    ENV.prepend_create_path "PATH", buildpath/"bin"

    dir = buildpath/"src/github.com/hashicorp/terraform"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      os = OS.mac? ? "darwin" : "linux"
      ENV["XC_OS"] = os
      ENV["XC_ARCH"] = "amd64"
      system "make", "tools", "bin"

      bin.install "pkg/#{os}_amd64/terraform"
      prefix.install_metafiles
    end
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~EOS
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    EOS
    system "#{bin}/terraform", "init"
    system "#{bin}/terraform", "graph"
  end
end
