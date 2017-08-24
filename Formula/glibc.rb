class BrewedGlibcNotOlderRequirement < Requirement
  fatal true

  satisfy(:build_env => false) do
    GlibcRequirement.system_version <= Glibc.version
  end

  def message
    <<-EOS.undent
      Your system's glibc version is #{GlibcRequirement.system_version}, and Linuxbrew's gcc version is #{Glibc.version}.
      Installing a version of glibc that is older than your system's can break formulae installed from source.
    EOS
  end
end

class GawkRequirement < Requirement
  fatal true

  satisfy(:build_env => false) do
    which "gawk"
  end

  def message
    <<-EOS.undent
      gawk is required to build glibc.
      Install gawk with your host package manager if you have sudo access.
        sudo apt-get install gawk
        sudo yum install gawk
    EOS
  end
end

class LinuxKernelRequirement < Requirement
  fatal true

  MINIMUM_LINUX_KERNEL_VERSION = "2.6.32".freeze

  def linux_kernel_version
    @linux_kernel_version ||= Version.new Utils.popen_read("uname -r")
  end

  satisfy(:build_env => false) do
    linux_kernel_version >= MINIMUM_LINUX_KERNEL_VERSION
  end

  def message
    <<-EOS.undent
      Linux kernel version #{MINIMUM_LINUX_KERNEL_VERSION} or greater is required by glibc.
      Your system has Linux kernel version #{linux_kernel_version}.
    EOS
  end
end

class Glibc < Formula
  desc "The GNU C Library"
  homepage "https://www.gnu.org/software/libc/"
  url "https://ftp.gnu.org/gnu/glibc/glibc-2.22.tar.gz"
  sha256 "a62610c4084a0fd8cec58eee12ef9e61fdf809c31e7cecbbc28feb8719f08be5"
  # tag "linuxbrew"

  bottle do
    sha256 "968d83ab9bbfee1166415e6edc59094e0018b689e9e5875ed1e7b031816d2c2f" => :x86_64_linux
  end

  option "with-current-kernel", "Compile for compatibility with kernel not older than your current one"

  depends_on BrewedGlibcNotOlderRequirement
  depends_on LinuxKernelRequirement
  depends_on GawkRequirement => :build

  # binutils 2.20 or later is required
  depends_on "binutils" => [:build, :recommended]

  # Linux kernel headers 2.6.19 or later are required
  depends_on "linux-headers" => [:build, :recommended]

  def install
    # Setting RPATH breaks glibc.
    %w[
      LDFLAGS LD_LIBRARY_PATH LD_RUN_PATH LIBRARY_PATH
      HOMEBREW_DYNAMIC_LINKER HOMEBREW_LIBRARY_PATHS HOMEBREW_RPATH_PATHS
    ].each { |x| ENV.delete x }
    gcc = Formula["gcc"]
    if gcc.installed? && ENV.compiler == "gcc-" + gcc.version.to_s.split(".")[0]
      # Use the original GCC specs file.
      specs = gcc.lib/"gcc/x86_64-unknown-linux-gnu/#{gcc.version}/specs.orig"
      raise "The original GCC specs file is missing: #{specs}" unless specs.readable?
      ENV["LDFLAGS"] = "-specs=#{specs}"

      # Fix error ld: cannot find -lc when upgrading glibc and compiling with a brewed gcc.
      ENV["BUILD_LDFLAGS"] = "-L#{opt_lib}" if opt_lib.directory?
    end

    # -Os confuses valgrind.
    ENV.O2

    # Use brewed ld.so.preload rather than the hotst's /etc/ld.so.preload
    inreplace "elf/rtld.c", '= "/etc/ld.so.preload";', '= SYSCONFDIR "/ld.so.preload";'

    mkdir "build" do
      args = [
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--enable-obsolete-rpc",
        # Fix error: selinux/selinux.h: No such file or directory
        "--without-selinux",
      ]
      kernel_version = `uname -r`.chomp.split("-")[0]
      args << "--enable-kernel=#{kernel_version}" if build.with? "current-kernel"
      args << "--with-binutils=#{Formula["binutils"].bin}" if build.with? "binutils"
      args << "--with-headers=#{Formula["linux-headers"].include}" if build.with? "linux-headers"
      system "../configure", *args

      system "make" # Fix No rule to make target libdl.so.2 needed by sprof
      system "make", "install"
      prefix.install_symlink "lib" => "lib64"
    end
  end

  def post_install
    # Fix permissions
    chmod 0755, [lib/"ld-#{version}.so", lib/"libc-#{version}.so"]

    # Install ld.so symlink.
    ln_sf lib/"ld-linux-x86-64.so.2", HOMEBREW_PREFIX/"lib/ld.so"

    # Symlink ligcc_s.so.1 where glibc can find it.
    # Fix the error: libgcc_s.so.1 must be installed for pthread_cancel to work
    ln_sf Formula["gcc"].opt_lib/"libgcc_s.so.1", lib if Formula["gcc"].installed?

    # Compile locale definition files
    mkdir_p lib/"locale"
    locales = ENV.map { |k, v| v if k[/^LANG$|^LC_/] && v != "C" }.compact
    locales << "en_US.UTF-8" # Required by gawk make check
    locales.uniq.each do |locale|
      lang, charmap = locale.split(".", 2)
      if !charmap.nil?
        system bin/"localedef", "-i", lang, "-f", charmap, locale
      else
        system bin/"localedef", "-i", lang, locale
      end
    end

    # Set the local time zone
    sys_localtime = Pathname.new "/etc/localtime"
    brew_localtime = Pathname.new prefix/"etc/localtime"
    (prefix/"etc").install_symlink sys_localtime if sys_localtime.exist? && !brew_localtime.exist?

    # Set zoneinfo correctly using the system installed zoneinfo
    sys_zoneinfo = Pathname.new "/usr/share/zoneinfo"
    brew_zoneinfo = Pathname.new share/"zoneinfo"
    share.install_symlink sys_zoneinfo if sys_zoneinfo.exist? && !brew_zoneinfo.exist?
  end

  test do
    system "#{lib}/ld-#{version}.so 2>&1 |grep Usage"
    system "#{lib}/libc-#{version}.so", "--version"
    system "#{bin}/locale", "--version"
  end
end
