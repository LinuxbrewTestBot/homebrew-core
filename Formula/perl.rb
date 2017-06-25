class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.26.0.tar.xz"
  sha256 "9bf2e3d0d72aad77865c3bdbc20d3b576d769c5c255c4ceb30fdb9335266bf55"
  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    sha256 "5a802e10df0c3845811f58c3f44f1c88d1a693d718997e3c45264055ec9393a7" => :sierra
    sha256 "238ee28350a29c19b8f154660ce58870fc0bf7033a54667a8e2c744a246dea47" => :el_capitan
    sha256 "ebb2181b33d2f08807d7a5d32e2c5332f861d9c3b3ca5fe46d3b7c14166f45f3" => :yosemite
    sha256 "09e48adbd98a9df1b480a631f967b05e9f195911cb10bda263e27458c2843d71" => :x86_64_linux
  end

  option "with-dtrace", "Build with DTrace probes"
  option "without-test", "Skip running the build test suite"

  deprecated_option "with-tests" => "with-test"

  unless OS.mac?
    depends_on "gdbm" => "with-libgdbm-compat"
    depends_on "berkeley-db"

    # required for XML::Parser
    depends_on "expat"
  end

  def install
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      %w[cpan/IPC-Cmd/lib/IPC/Cmd.pm dist/Time-HiRes/Changes
         dist/Time-HiRes/HiRes.pm dist/Time-HiRes/HiRes.xs
         dist/Time-HiRes/Makefile.PL dist/Time-HiRes/fallback/const-c.inc
         dist/Time-HiRes/t/clock.t pod/perl588delta.pod
         pod/perlperf.pod].each do |f|
        inreplace f do |s|
          s.gsub! "clock_gettime", "perl_clock_gettime"
          s.gsub! "clock_getres", "perl_clock_getres", false
        end
      end
    end

    args = %W[
      -des
      -Dprefix=#{prefix}
      -Dprivlib=#{lib}/perl5/#{version}
      -Dsitelib=#{lib}/perl5/site_perl/#{version}
      -Dotherlibdirs=#{HOMEBREW_PREFIX}/lib/perl5/site_perl/#{version}
      -Dperlpath=#{opt_bin}/perl
      -Dstartperl=#!#{opt_bin}/perl
      -Dman1dir=#{man1}
      -Dman3dir=#{man3}
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]

    args << "-Dusedtrace" if build.with? "dtrace"
    args << "-Dusedevel" if build.head?
    # Fix for https://github.com/Linuxbrew/homebrew-core/issues/405
    args << "-Dlocincpth=#{HOMEBREW_PREFIX}/include" if OS.linux?

    system "./Configure", *args
    system "make"

    # OS X El Capitan's SIP feature prevents DYLD_LIBRARY_PATH from being
    # passed to child processes, which causes the make test step to fail.
    # https://rt.perl.org/Ticket/Display.html?id=126706
    # https://github.com/Homebrew/legacy-homebrew/issues/41716
    if MacOS.version < :el_capitan
      system "make", "test" if build.with? "test"
    end

    system "make", "install"

    # expose libperl.so to ensure we aren't using a brewed executable
    # but a system library
    if OS.linux?
      perl_core = Pathname.new(`#{bin/"perl"} -MConfig -e 'print $Config{archlib}'`)+"CORE"
      lib.install_symlink perl_core/"libperl.so"
    end
  end

  def caveats; <<-EOS.undent
    By default non-brewed cpan modules are installed to the Cellar. If you wish
    for your modules to persist across updates we recommend using `local::lib`.

    You can set that up like this:
      PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
      echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"' >> #{shell_profile}
    EOS
  end

  def post_install
    # CPAN modules installed via the system package manager will not be visible to
    # brewed Perl. As a temporary measure, install critical CPAN modules to ensure
    # they are available. See https://github.com/Linuxbrew/homebrew-core/pull/1064
    unless OS.mac?
      ENV.with_build_environment do
        ENV["PERL_MM_USE_DEFAULT"] = "1"
        system bin/"cpan", "-i", "XML::Parser"
        system bin/"cpan", "-i", "XML::SAX"
      end
    end
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
