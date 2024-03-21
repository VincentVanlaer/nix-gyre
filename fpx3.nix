{
  fetchurl,
  stdenvNoCC,
  perl,
}:
 stdenvNoCC.mkDerivation {
    version = "0";
    name = "fpx3";

    src = fetchurl {
      url = "http://user.astro.wisc.edu/~townsend/resource/download/sdk2/src/fpx3.tar.gz";
      hash = "sha256-Yvr87JPrLNp/SQ/0TozIFldlrXv0eZS3O1n41KE4zGg=";
    };

    buildInputs = [perl];

    installPhase = ''
      mkdir -p $out/bin
      cp fpx3 $out/bin
      sed 's/`hostname`/"jailed-by-nix"/' -i $out/bin/fpx3
    '';
  }
