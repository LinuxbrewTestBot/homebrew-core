# hunspell: Build a bottle for Linuxbrew
class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/archive/v1.4.1.tar.gz"
  sha256 "c4476aff0ced52eec334eae1e8d3fdaaebdd90f5ecd0b57cf2a92a6fd220d1bb"

  bottle do
    sha256 "44097c8c6baf58143e57679ff5da818a8da2e035d3aa9a64f4585786161f03ed" => :x86_64_linux
  end

  depends_on "readline"

  conflicts_with "freeling", :because => "both install 'analyze' binary"

  # hunspell does not prepend $HOME to all USEROODIRs
  # https://github.com/hunspell/hunspell/issues/32
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/684440d/hunspell/prepend_user_home_to_useroodirs.diff"
    sha256 "456186c9e569c51065e7df2a521e325d536ba4627d000ab824f7e97c1e4bc288"
  end

  def install
    ENV.deparallelize

    # The following line can be removed on release of next stable version
    inreplace "configure", "1.4.0", "1.4.1"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui",
                          "--with-readline"
    system "make"
    system "make", "install"

    pkgshare.install "tests"
  end

  def caveats; <<-EOS.undent
    Dictionary files (*.aff and *.dic) should be placed in
    ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
    provides no dictionaries for Hunspell, but you can download
    compatible dictionaries from other sources, such as
    https://wiki.openoffice.org/wiki/Dictionaries .
    EOS
  end

  test do
    cp_r "#{pkgshare}/tests/.", testpath
    system "./test.sh"
  end
end
