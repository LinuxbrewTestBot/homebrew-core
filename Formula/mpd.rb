class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://www.musicpd.org/download/mpd/0.21/mpd-0.21.19.tar.xz"
  sha256 "d3275e11d85637adde250cadf3b4f5aec2144228f0d8085767493fc46c55b2f9"
  head "https://github.com/MusicPlayerDaemon/MPD.git"

  bottle do
    sha256 "8ae6ae0fa462ebaa09d1cbc079c8d09f49e550fe7c0402d7b0ef35988757f6e4" => :catalina
    sha256 "bbd105f0749b0071115107cf1f8a29441dff3cd779ca3877291fe99c3e6b871e" => :mojave
    sha256 "178ab20d42fcab20695b044af4591a1cc7691615901e183f79ff581451a74614" => :high_sierra
    sha256 "2c42b62a31d40550dbbc84984eafc249de9c3a03d86f5d2a6e4bc3f6939ae098" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "expat"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "lame"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "libid3tag"
  depends_on "libmpdclient"
  depends_on "libnfs"
  depends_on "libsamplerate"
  depends_on "libupnp"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "sqlite"

  unless OS.mac?
    fails_with :gcc => "5"
    depends_on "gcc@6" => :build
    depends_on "curl"
  end

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx if OS.mac?
    ENV.cxx11 unless OS.mac?

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      -Dlibwrap=disabled
      -Dmad=disabled
      -Dmpcdec=disabled
      -Dsoundcloud=disabled
      -Dao=enabled
      -Dbzip2=enabled
      -Dexpat=enabled
      -Dffmpeg=enabled
      -Dfluidsynth=enabled
      -Dnfs=enabled
      -Dupnp=enabled
      -Dvorbisenc=enabled
    ]

    system "meson", *args, "output/release", "."
    system "ninja", "-C", "output/release"
    ENV.deparallelize # Directories are created in parallel, so let's not do that
    system "ninja", "-C", "output/release", "install"

    (etc/"mpd").install "doc/mpdconf.example" => "mpd.conf"
  end

  def caveats; <<~EOS
    MPD requires a config file to start.
    Please copy it from #{etc}/mpd/mpd.conf into one of these paths:
      - ~/.mpd/mpd.conf
      - ~/.mpdconf
    and tailor it to your needs.
  EOS
  end

  plist_options :manual => "mpd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/mpd</string>
            <string>--no-daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProcessType</key>
        <string>Interactive</string>
    </dict>
    </plist>
  EOS
  end

  test do
    # oss_output: Error opening OSS device "/dev/dsp": No such file or directory
    # oss_output: Error opening OSS device "/dev/sound/dsp": No such file or directory
    return if ENV["CI"]

    pid = fork do
      exec "#{bin}/mpd --stdout --no-daemon --no-config"
    end
    sleep 2

    begin
      ohai "Connect to MPD command (localhost:6600)"
      TCPSocket.open("localhost", 6600) do |sock|
        assert_match "OK MPD", sock.gets
        ohai "Ping server"
        sock.puts("ping")
        assert_match "OK", sock.gets
        sock.close
      end
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
