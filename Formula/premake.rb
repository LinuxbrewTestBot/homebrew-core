# premake: Build a bottle for Linuxbrew
class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
  sha256 "0fa1ed02c5229d931e87995123cdb11d44fcc8bd99bba8e8bb1bbc0aaa798161"
  head "https://github.com/premake/premake-core.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68c9aa47ac6de8238a61bcd58609a2fc91c535a66bf7ab7be8aed19a1042e03f" => :el_capitan
    sha256 "288d7582575b6b3d9f8cf051a8c6df2213015437fe3d66257ab3e236f90e189a" => :yosemite
    sha256 "4ca2745c7e5628a8f830a6eccded4f4e768c17648fef673700a7ba322415b0a9" => :mavericks
  end

  devel do
    url "https://github.com/premake/premake-core/releases/download/v5.0.0-alpha6/premake-5.0.0-alpha6-src.zip"
    sha256 "9c13372699d25824cba1c16a0483507a6a28903e2556ffb148b288c189403aee"
  end

  def install
    if build.head?
      system "make", "-f", "Bootstrap.mak", "osx"
      system "./premake5", "gmake"
    end

    system "make", "-C", "build/gmake.#{OS.mac? ? "macosx" : "unix"}"

    if build.devel? || build.head?
      bin.install "bin/release/premake5"
    else
      bin.install "bin/release/premake4"
    end
  end

  test do
    if stable?
      assert_match version.to_s, shell_output("#{bin}/premake4 --version", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/premake5 --version")
    end
  end
end
