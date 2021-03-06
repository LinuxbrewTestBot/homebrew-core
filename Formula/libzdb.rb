class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.tar.gz"
  sha256 "005ddf4b29c6db622e16303298c2f914dfd82590111cea7cfd09b4acf46cf4f2"
  revision 2

  bottle do
    cellar :any
    sha256 "1d523ee67b9eb18d8e4311f722b24d60c3ca35994de9e2cb945f20766e922630" => :catalina
    sha256 "e33de57009c4bee656f08539b7eb1e982db84e6b2692f8446d1364d1ff5f147b" => :mojave
    sha256 "ef5be4752f5a6f663841299ee699e9c3e361d9dfa70022d82c4269bcb3707d38" => :high_sierra
    sha256 "0cd4ae0b4d0295ab8b1d198c6f942d273701621c4e9cb7557ac260fefc2629c7" => :x86_64_linux
  end

  depends_on :macos => :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sqlite"

  unless OS.mac?
    depends_on "gcc@7" # C++ 17 is required

    fails_with :gcc => "4"
    fails_with :gcc => "5"
    fails_with :gcc => "6"
  end

  def install
    # workaround for error: 'assert' was not declared in this scope
    system "sed", "-i", "1,1i#include <cassert>", "test/zdbpp.cpp" unless OS.mac?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
