class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.18/libsecret-0.18.5.tar.xz"
  sha256 "9ce7bd8dd5831f2786c935d82638ac428fa085057cc6780aba0e39375887ccb3"

  bottle do
    sha256 "9a875f5a0ad4d45f01431d73da21eb2e8087023114526349a1d122ef28a25451" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-sed" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "docbook-xsl" => :build
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "gobject-introspection" => :recommended
  depends_on "vala" => :optional

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-gobject-introspection" if build.with? "gobject-introspection"
    args << "--enable-vala" if build.with? "vala"

    system "./configure", *args

    # https://bugzilla.gnome.org/show_bug.cgi?id=734630
    inreplace "Makefile", "sed", "gsed" unless OS.linux?

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libsecret/secret.h>

      const SecretSchema * example_get_schema (void) G_GNUC_CONST;

      const SecretSchema *
      example_get_schema (void)
      {
          static const SecretSchema the_schema = {
              "org.example.Password", SECRET_SCHEMA_NONE,
              {
                  {  "number", SECRET_SCHEMA_ATTRIBUTE_INTEGER },
                  {  "string", SECRET_SCHEMA_ATTRIBUTE_STRING },
                  {  "even", SECRET_SCHEMA_ATTRIBUTE_BOOLEAN },
                  {  "NULL", 0 },
              }
          };
          return &the_schema;
      }

      int main()
      {
          example_get_schema();
          return 0;
      }
    EOS

    flags = [
      "-I#{include}/libsecret-1",
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
