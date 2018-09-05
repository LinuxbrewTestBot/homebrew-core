class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.1.4/libtirpc-1.1.4.tar.bz2"
  sha256 "2ca529f02292e10c158562295a1ffd95d2ce8af97820e3534fe1b0e3aec7561d"
  # tag "linuxbrew"

  bottle do
  end

  depends_on "krb5" => :optional unless OS.mac?

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      *("--disable-gssapi" if build.without? "krb5")
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rpc/des_crypt.h>
      #include <stdio.h>
      int main () {
        char key[] = "My8digitkey1234";
        if (sizeof(key) != 16)
          return 1;
        des_setparity(key);
        printf("%lu\\n", sizeof(key));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/tirpc", "-ltirpc", "-o", "test"
    system "./test"
  end
end
