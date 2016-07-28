# libtasn1: Build a bottle for Linuxbrew
class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.9.tar.gz"
  sha256 "4f6f7a8fd691ac2b8307c8ca365bad711db607d4ad5966f6938a9d2ecd65c920"

  bottle do
    cellar :any
    sha256 "a573af5472e41b7276cf628f782558645b9e331a890f9383e791b43edd695fce" => :x86_64_linux
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"pkix.asn").write <<-EOS.undent
      PKIX1 { }
      DEFINITIONS IMPLICIT TAGS ::=
      BEGIN
      Dss-Sig-Value ::= SEQUENCE {
           r       INTEGER,
           s       INTEGER
      }
      END
    EOS
    (testpath/"assign.asn1").write <<-EOS.undent
      dp PKIX1.Dss-Sig-Value
      r 42
      s 47
    EOS
    system "#{bin}/asn1Coding", "pkix.asn", "assign.asn1"
    assert_match /Decoding: SUCCESS/, shell_output("#{bin}/asn1Decoding pkix.asn assign.out PKIX1.Dss-Sig-Value 2>&1")
  end
end
