
{
  stdenv,
  fetchurl,
  gfortran,
  pkg-config,
}: let
  version = "3.0";
in
  stdenv.mkDerivation {
    inherit version;
    pname = "lapack";
    
    src = fetchurl {
      url = "https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.11.tar.gz";
      hash = "sha256-Wls7rCdwnYxmKGt6DR178tcXDsGJoadW/fgSyXqn/RA=";
    };
    
    nativeBuildInputs = [gfortran pkg-config];

    buildPhase = ''
      make blaslib
      make lib
    '';

    configurePhase = ''
      cp ${./lapack.make.inc} make.inc
    '';

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $out/lib/pkgconfig

      cp BLAS/SRC/libblas.a $out/lib
      cp SRC/liblapack.a $out/lib
      cp TESTING/MATGEN/libtmg.a $out/lib
          
      cat <<EOF > $out/lib/pkgconfig/lapack.pc
      Name: lapack
      Version: ${version}
      Description: LAPACK 
      Libs: -L$out/lib -llapack -lblas
      EOF
    '';
  }
