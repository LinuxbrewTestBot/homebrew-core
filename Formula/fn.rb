class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.5.92.tar.gz"
  sha256 "b478c117cfdae5fe791704d8cbf88719229f26c3fef5a0bf33988812bf6e6d11"

  bottle do
    cellar :any_skip_relocation
    sha256 "3870feaa4fd4c07359f063023d343a2efba22899a16f61b82b2cc02fa2d688db" => :catalina
    sha256 "d54516bc73c7a5918d97854122a304257bc97d0ddd5bbb2e6c9fb80d3d084853" => :mojave
    sha256 "d7ace0d32f6c48f5d66837dbe0e74192f16fdf2ed8c840da3affd936d8ee69d9" => :high_sierra
    sha256 "f3fb94afb5a3d2c99a05b839cda3da6dbcd0245dd09c0db1ac12588cd9662661" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "#{bin}/fn"
    prefix.install_metafiles
  end

  test do
    require "socket"
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system "#{bin}/fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath/"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath/"func.yaml", :exist?, "expected file func.yaml doesn't exist"
    server = TCPServer.new("localhost", 0)
    port = server.addr[1]
    pid = fork do
      loop do
        socket = server.accept
        response = '{"id":"01CQNY9PADNG8G00GZJ000000A","name":"myapp","created_at":"2018-09-18T08:56:08.269Z","updated_at":"2018-09-18T08:56:08.269Z"}'
        socket.print "HTTP/1.1 200 OK\r\n" \
                    "Content-Length: #{response.bytesize}\r\n" \
                    "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    begin
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "Successfully created app:  myapp"
      output = shell_output("#{bin}/fn create app myapp")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
