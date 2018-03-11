# spigot: Build a bottle for Linuxbrew
class Spigot < Formula
  desc "Command-line streaming exact real calculator"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/spigot/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/spigot/spigot-20180308.e7e8a3f.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/spigot-20180308.e7e8a3f.tar.gz"
  sha256 "d14db16d457bf63689bd37ce1e3c602cfa5fae71178a9a0360a203e251ef31cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6fc3baea088383656090c9994a9347ac9b054f643ef545f838a4cdde488cabc" => :high_sierra
    sha256 "7add8aa7614d3b75194907d6251aa8dd90fae7f2c4c7d7779342bb33bcd1ac3a" => :sierra
    sha256 "2ee4c3d1d5ef96e1745050590a158b0bf8a31574bcd0632e6b07bb299c2eb64f" => :el_capitan
    sha256 "8308fa4c726d8710ae692b6c82a3aee7a3d70942563ac995f882eb1e419b1e39" => :x86_64_linux
  end

  depends_on "gmp" unless OS.mac?

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Get Ramanujan's number of decimal places of Tau in base10
    expected = <<~EOS
      6.28318530717958647692528676655900576839433879875021164194988918461563281
      2572417997256069650684234135964296173026564613294187689219101164463450718
      8162569622349005682054038770422111192892458979098607639288576219513318668
      9225695129646757356633054240381829129713384692069722090865329642678721452
      0498282547449174013212631176349763041841925658508183430728735785180720022
      6610610976409330427682939038830232188661145407315191839061843722347638652
      2358621023709614892475992549913470377150544978245587636602389825966734672
      4881313286172042789892790449474381404359721887405541078434352586353504769
      3496369353388102640011362542905271216555715426855155792183472743574429368
      8180244990686029309917074210158455937851784708403991222425804392172806883
      6319627259549542619921037414422699999996745956099902119463465632192637190
      0489189106938166052850446165066893700705238623763420200062756775057731750
      6641676284123435533829460719650698085751093746231912572776470757518750391
      5563715561064342453613226003855753222391818432840397876190514402130971726
      5577318723067636559364606039040706037059379915472451988277824994435505669
      5826303114971448490830139190165906623372345571177815019676350927492987863
      8510120801855403342278019697648025716723207127415320209420363885911192397
      8935356748988965107595494536942080950692924160933685181389825866273540579
      7830420950432411393204811607630038702250676486007117528049499294652782839
      8545208539845593564709563272018683443282439849172630060572365949111413499
      6770109891771738539913818544215950186059106423306899744055119204729613309
      9823976366959550713273961485308505572510363683514934578195554558760016329
      4120032290498384346434429544700282883947137096322722314705104266951483698
      9368770466478147882866690955248337250379671389711241
    EOS
    assert_equal shell_output("#{bin}/spigot -d1729 tau").strip,
                 expected.delete!("\n")
  end
end
