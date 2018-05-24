# nanomsgxx: Build a bottle for Linuxbrew
class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  revision 2

  bottle do
    cellar :any
    sha256 "01db719be7a835bce8c61d3dd3e44895243de87418008498c2083af7f0f7adfc" => :high_sierra
    sha256 "f127d17530e3327e215c3dc2ffb5765655d491b1d4fa39bec88e7fff4dee670e" => :sierra
    sha256 "6757cefbf5d92c638b8b32f27414e5ffaf80cf985aee51a8919cd645af0a09a5" => :el_capitan
    sha256 "33a37f09f7c10552ff745d613530bcf29c63614d4bf5b9fefb84a37a8d1bd2a2" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build

  depends_on "nanomsg"

  def install
    args = %W[
      --static
      --shared
      --prefix=#{prefix}
    ]

    system "python", "./waf", "configure", *args
    system "python", "./waf", "build"
    system "python", "./waf", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      int main(int argc, char **argv) {
        std::cout << "Hello Nanomsgxx!" << std::endl;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lnnxx", "test.cpp"

    assert_equal "Hello Nanomsgxx!\n", shell_output("#{testpath}/a.out")
  end
end
