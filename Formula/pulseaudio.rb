class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-10.99.1.tar.xz"
  sha256 "c9791844569d8d0adb468c183d0d9fb6ac12b9db34a4a078a7773c8bac993f32"

  bottle do
    sha256 "5f1dbafa53bd5cc117e08d8c1c6207fcbb42865e3e8d202742cb9dc03971c6cb" => :sierra
    sha256 "4a84b0cfa38aa689c2e542e235a64d15cd8d5dd447eb4f7b03a6a11985e0d3dc" => :el_capitan
    sha256 "fc358d4cfc3b4d3a0e7822d09909cbe133842aced9e8eb10c64133f52d7f9770" => :yosemite
    sha256 "cba68b3b8fcf0bf3c4d311fb0dfd7ec247990ffbca2f7ecdb39eda3a4838ed78" => :x86_64_linux
  end

  head do
    url "https://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  option "with-nls", "Build with native language support"

  deprecated_option "without-speex" => "without-speexdsp"

  depends_on "pkg-config" => :build

  if build.with? "nls"
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  depends_on "libtool" => :run
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "openssl"
  depends_on "speexdsp" => :recommended
  depends_on "glib" => :optional
  depends_on "gconf" => :optional
  depends_on "gtk+3" => :optional
  depends_on "jack" => :optional

  unless OS.mac?
    depends_on "m4" => :build
    depends_on "libcap"
    depends_on "expat"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  fails_with :clang do
    build 421
    cause "error: thread-local storage is unsupported for the current target"
  end

  def install
    unless OS.mac?
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-neon-opt
      --with-mac-sysroot=#{MacOS.sdk_path}
      --with-mac-version-min=#{MacOS.version}
      --disable-x11
    ]

    args << "--disable-nls" if build.without? "nls"

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"pulseaudio", "--dump-modules"
  end
end
