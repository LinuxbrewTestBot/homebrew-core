# go: Build a bottle for Linux
class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://golang.org"

  stable do
    url "https://dl.google.com/go/go1.13.4.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.13.4.src.tar.gz"
    sha256 "95dbeab442ee2746b9acf0934c8e2fc26414a0565c008631b04addb8c02e7624"

    go_version = version.to_s.split(".")[0..1].join(".")
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}"
    end
  end

  bottle do
    sha256 "77af3e8081a002c86b4b87ec97dc5dc28cab49704913a4db22ebc7ce838dc6ad" => :catalina
    sha256 "2fc74073a90a7073dab940868ac23fa6cd465af8a39ed2d882b18d62bec2265f" => :mojave
    sha256 "20d5242dbbb08128c254a1cc96f55cfc9add74c9567600dfd9366f3d028f5563" => :high_sierra
  end

  head do
    url "https://go.googlesource.com/go.git"

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  depends_on :macos => :el_capitan

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    if OS.mac?
      url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
      sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
    elsif OS.linux?
      if Hardware::CPU.intel?
        url "https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz"
        sha256 "702ad90f705365227e902b42d91dd1a40e48ca7f67a2f4b2fd052aaa4295cd95"
      elsif Hardware::CPU.arm?
        if Hardware::CPU.is_64_bit?
          url "https://dl.google.com/go/go1.9.linux-arm64.tar.gz"
          sha256 "0958dcf454f7f26d7acc1a4ddc34220d499df845bc2051c14ff8efdf1e3c29a6"
        else
          url "https://dl.google.com/go/go1.9.linux-armv6l.tar.gz"
          sha256 "f52ca5933f7a8de2daf7a3172b0406353622c6a39e67dd08bbbeb84c6496f487"
        end
      end
    end
  end

  def install
    # Fixes: Error: Failure while executing: ../bin/ldd ../line-clang.elf: Permission denied
    unless OS.mac?
      chmod "+x", Dir.glob("src/debug/dwarf/testdata/*.elf")
      chmod "+x", Dir.glob("src/debug/elf/testdata/*-exec")
    end

    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = OS.mac? ? "darwin" : "linux"
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Build and install godoc
    ENV.prepend_path "PATH", bin
    ENV["GOPATH"] = buildpath
    (buildpath/"src/golang.org/x/tools").install resource("gotools")
    cd "src/golang.org/x/tools/cmd/godoc/" do
      system "go", "build"
      (libexec/"bin").install "godoc"
    end
    bin.install_symlink libexec/"bin/godoc"
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    # godoc was installed
    assert_predicate libexec/"bin/godoc", :exist?
    assert_predicate libexec/"bin/godoc", :executable?

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end
