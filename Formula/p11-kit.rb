class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.11/p11-kit-0.23.11.tar.gz"
  sha256 "b243c8daa573f85cb9873352a4c38563812fe3045e960593eb45db7dfdea4a2b"

  bottle do
    sha256 "0afa192a487fb343c399d8ba552f35c670206d4a3402ad3096468f1c946b11da" => :x86_64_linux
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libffi"
  depends_on "pkg-config" => :build

  def install
    # Fix "error: unknown type name 'locale_t'"
    # Reported 25 May 2018 https://github.com/p11-glue/p11-kit/issues/158
    inreplace %w[common/debug.c common/library.c common/message.c
                 common/test-message.c],
              "#include <locale.h>", "#include <xlocale.h>" if OS.mac?

    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-trust-module",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-module-config=#{etc}/pkcs11/modules",
                          "--without-libtasn1"
    system "make"
    system "make", "check" if OS.mac? # Takes more than 30 min on circle.ci
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
