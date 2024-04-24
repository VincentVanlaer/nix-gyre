{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  pkg-config,
  withCrlibm ? true,
  crlibm-fortran,
}: let
  version = "3.0";
  crlibm-patch =
    if withCrlibm
    then
      /*
      bash
      */
      ''
        ${./crmath_lapack}/fix_crmath_lapack.sh
        export FFLAGS=`pkg-config --cflags crlibm-fortran`
        export LDLIBS=`pkg-config --libs crlibm-fortran`
      ''
    else "";
in
  stdenv.mkDerivation {
    inherit version;
    pname = "lapack";

    src = fetchurl {
      url = "https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.11.tar.gz";
      hash = "sha256-Wls7rCdwnYxmKGt6DR178tcXDsGJoadW/fgSyXqn/RA=";
    };

    nativeBuildInputs = [gfortran pkg-config];
    buildInputs = lib.optional withCrlibm crlibm-fortran;

    buildPhase = ''
      make blaslib
      make lib
    '';

    configurePhase = ''
      ${crlibm-patch}
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
