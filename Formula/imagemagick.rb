# imagemagick: Build a bottle for Linuxbrew
class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick-7.0.7-29.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-7.0.7-29.tar.xz"
  sha256 "1603f0a4107bd1c67c50eb2868484faff8008ea2ba5657d69c20a02906e604bb"
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    sha256 "63c4325986b8329cf48ae3cc18a80e1c281b2b615472faf493242a1a5623d4d5" => :high_sierra
    sha256 "47045062bca58cbd8ca7dc77ab1200256940f5b0960e245c27fb14868590f872" => :sierra
    sha256 "510ad11ca7718c7b3f9d157f18c5f3a548fb525836e9039772a58e787fd43e67" => :el_capitan
    sha256 "68ed6ca9aebe9fd0fe45af49865482f4911f8c86a4b3e4c7bd24f50ff20c079f" => :x86_64_linux
  end

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-libde265", "Compile with HEIF support"
  option "with-opencl", "Compile with OpenCL support"
  option "with-openmp", "Compile with OpenMP support"
  option "with-perl", "Compile with PerlMagick"
  option "without-magick-plus-plus", "disable build/install of Magick++"
  option "without-modules", "Disable support for dynamically loadable modules"
  option "without-threads", "Disable threads support"
  option "with-zero-configuration", "Disables depending on XML configuration files"

  deprecated_option "enable-hdri" => "with-hdri"
  deprecated_option "with-gcc" => "with-openmp"
  deprecated_option "with-jp2" => "with-openjpeg"

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "xz"

  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "freetype" => :recommended

  depends_on :x11 => :optional
  depends_on "fontconfig" => :optional
  depends_on "little-cms" => :optional
  depends_on "little-cms2" => :optional
  depends_on "libde265" => :optional
  depends_on "libwmf" => :optional
  depends_on "librsvg" => :optional
  depends_on "liblqr" => :optional
  depends_on "openexr" => :optional
  depends_on "ghostscript" => :optional
  depends_on "webp" => :optional
  depends_on "openjpeg" => :optional
  depends_on "fftw" => :optional
  depends_on "pango" => :optional
  depends_on "perl" => :optional

  if build.with? "openmp"
    depends_on "gcc"
    fails_with :clang
  end

  depends_on "bzip2" unless OS.mac?
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-shared
      --enable-static
    ]

    if build.without? "modules"
      args << "--without-modules"
    else
      args << "--with-modules"
    end

    if build.with? "opencl"
      args << "--enable-opencl"
    else
      args << "--disable-opencl"
    end

    if build.with? "openmp"
      args << "--enable-openmp"
    else
      args << "--disable-openmp"
    end

    if build.with? "webp"
      args << "--with-webp=yes"
    else
      args << "--without-webp"
    end

    if build.with? "openjpeg"
      args << "--with-openjp2"
    else
      args << "--without-openjp2"
    end

    args << "--without-gslib" if build.without? "ghostscript"
    args << "--with-perl" << "--with-perl-options='PREFIX=#{prefix}'" if build.with? "perl"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--without-magick-plus-plus" if build.without? "magick-plus-plus"
    args << "--enable-hdri=yes" if build.with? "hdri"
    args << "--without-fftw" if build.without? "fftw"
    args << "--without-pango" if build.without? "pango"
    args << "--without-threads" if build.without? "threads"
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--without-x" if build.without? "x11"
    args << "--with-fontconfig=yes" if build.with? "fontconfig"
    args << "--with-freetype=yes" if build.with? "freetype"
    args << "--enable-zero-configuration" if build.with? "zero-configuration"
    args << "--without-wmf" if build.without? "libwmf"

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    s = <<~EOS
      For full Perl support you may need to adjust your PERL5LIB variable:
        export PERL5LIB="#{HOMEBREW_PREFIX}/lib/perl5/site_perl":$PERL5LIB
    EOS
    s if build.with? "perl"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
