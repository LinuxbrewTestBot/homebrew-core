class Valkyrie < Formula
  desc "GUI for Memcheck and Helgrind tools in Valgrind 3.6.X"
  homepage "http://valgrind.org/downloads/guis.html"
  url "http://valgrind.org/downloads/valkyrie-2.0.0.tar.bz2"
  sha256 "a70b9ffb2409c96c263823212b4be6819154eb858825c9a19aad0ae398d59b43"

  head "svn://svn.valgrind.org/valkyrie/trunk"

  bottle do
    revision 1
    sha256 "839cedda34c2f4af6eefee54bbcbd1557956b917efabcc58c2c7d492d91a236a" => :x86_64_linux
  end

  depends_on "qt"
  depends_on "valgrind"

  def install
    # Prevents "undeclared identifier" errors for getpid, usleep, and getuid.
    # Reported 21st Apr 2016 to https://bugs.kde.org/show_bug.cgi?id=362033
    inreplace "src/utils/vk_utils.h",
      "#include <iostream>",
      "#include <iostream>\n#include <unistd.h>"

    system "qmake", "PREFIX=#{prefix}"
    system "make", "install"
    prefix.install bin/"valkyrie.app" if OS.mac?
  end

  test do
    if OS.mac?
      assert_match version.to_s, shell_output("#{prefix}/valkyrie.app/Contents/MacOS/valkyrie -v 2>/dev/null")
    else
      assert_match version.to_s, shell_output("#{bin}/valkyrie -v 2>/dev/null")
    end
  end
end
