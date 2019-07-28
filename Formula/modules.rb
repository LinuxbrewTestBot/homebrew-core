# modules: Build a bottle for Linuxbrew
class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.2.5/modules-4.2.5.tar.bz2"
  sha256 "f9f898d489d18fb1a9637a15e7c036a75549b3a8b3716cd70c2dff1c80ef53c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca75f7d31f9698e69d0f89d7b99474dba36c73c67fc698f29e8af78a18d92cbb" => :mojave
    sha256 "8d3e5a0ebb734938a32fd734e49c8bc258c64a753327a312a1a5a8d78bc2f4b6" => :high_sierra
    sha256 "9b402a25481669f3d92d900249dc8741ef5bce5d6ad8b64a9e8efa342572e814" => :sierra
    sha256 "a19c4dc7eb28bebbc3cfaf7a075364d0c02ef625bf2a2eddb6acfeb8c6ac9f60" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "tcl-tk"
    depends_on "less"
  end

  def install
    tcl = OS.mac? ? "#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework" : Formula["tcl-tk"].opt_lib
    with_tclsh = OS.mac? ? "" : "--with-tclsh=#{Formula["tcl-tk"].opt_bin}/tclsh"
    with_pager = OS.mac? ? "" : "--with-pager=#{Formula["less"].opt_bin}/less"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{tcl}
      #{with_tclsh}
      #{with_pager}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    To activate modules, add the following at the end of your .zshrc:
      source #{opt_prefix}/init/zsh
    You will also need to reload your .zshrc:
      source ~/.zshrc
  EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    if OS.mac?
      output = shell_output("zsh -c 'source #{prefix}/init/zsh; module' 2>&1")
    else
      output = shell_output("sh -c '. #{prefix}/init/sh; module' 2>&1")
    end
    assert_match version.to_s, output
  end
end
