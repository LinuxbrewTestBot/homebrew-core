class Docbook2x < Formula
  desc "Convert DocBook to UNIX manpages and GNU TeXinfo"
  homepage "https://docbook2x.sourceforge.io/"
  url "https://downloads.sourceforge.net/docbook2x/docbook2X-0.8.8.tar.gz"
  sha256 "4077757d367a9d1b1427e8d5dfc3c49d993e90deabc6df23d05cfe9cd2fcdc45"
  revision 1 unless OS.mac?

  bottle do
    cellar :any_skip_relocation
    sha256 "d1bc1003ccbe24b5495735c8993fdeb4d038ec2cb635985b028a443a6a41d7eb" => :x86_64_linux
  end

  depends_on "docbook"
  depends_on "libxslt" unless OS.mac?

  def install
    inreplace "perl/db2x_xsltproc.pl", "http://docbook2x.sf.net/latest/xslt", "#{share}/docbook2X/xslt"
    inreplace "configure", "${prefix}", prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    (testpath/"brew.1.xml").write <<-EOS.undent
      <?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE refentry PUBLIC "-//OASIS//DTD DocBook XML V4.4//EN"
                         "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd">
      <refentry id='brew1'>
      <refmeta>
        <refentrytitle>brew</refentrytitle>
        <manvolnum>1</manvolnum>
      </refmeta>
      <refnamediv>
        <refname>brew</refname>
        <refpurpose>The missing package manager for macOS</refpurpose>
      </refnamediv>
      </refentry>
    EOS
    system bin/"docbook2man", testpath/"brew.1.xml"
    assert_predicate testpath/"brew.1", :exist?, "Failed to create man page!"
  end
end
