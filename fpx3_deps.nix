{
  stdenvNoCC,
  perl,
}:
 stdenvNoCC.mkDerivation {
    version = "0";
    name = "fpx3_deps";

    src = ./fpx3_deps;
    dontUnpack = true;

    buildInputs = [perl];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/fpx3_deps
    '';
  }

