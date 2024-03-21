{
  lib,
  stdenv,
  fetchgit,
  gfortran,
  hdf5-fortran,
  lapack,
  lapack95,
  fpx3,
  fpx3_deps,
  pkg-config,
}: let
  makeFilesToPatch = "src/tide/Makefile src/mesa/Makefile src/math/unit/Makefile src/interp/Makefile src/build/Make.inc src/build/Makefile";
  linkProgsToPkgConfig = {
    "hdf5_link" = "pkg-config --libs hdf5_fortran";
    "lapack_link" = "pkg-config --libs lapack";
    "lapack95_link" = "pkg-config --libs lapack95";
    "odepack_link" = "pkg-config --libs odepack";
  };
in
  stdenv.mkDerivation {
    pname = "gyre";
    version = "7.1";

    src = fetchgit {
      url = "https://github.com/rhdtownsend/gyre";
      rev = "5c11e7316d993a568febf34011660dfdb6ae1054";
      hash = "sha256-vvY43KBOTYd+iykVyd+7x0kZ+WwTTZoi3l1oWKKCcSM=";
    };

    patches = [./gyre.patch];

    CRMATH = "no";
    FFLAGS = [" -I${hdf5-fortran.dev}/include" " -I${lapack95}/include"];

    nativeBuildInputs = [gfortran pkg-config fpx3 fpx3_deps];
    buildInputs = [hdf5-fortran lapack lapack95];

    configurePhase = ''
      sed 's/`lapack95_link`/`lapack95_link` `lapack_link`/' -i src/build/Make.inc
      ${(lib.strings.concatStringsSep "\n" (lib.attrsets.mapAttrsToList (name: value: "sed -i \"s|${name}|${value}|\" ${makeFilesToPatch}") linkProgsToPkgConfig))}
      echo "echo passed" > src/build/check_sdk_version
      sed -i "s|NIX_GYRE_DIR|$out|" src/common/gyre_constants.fpp
    '';

    installPhase = ''
      mkdir -p $out/bin

      cp bin/* $out/bin
      cp -r data $out
    '';
  }
