{
  lib,
  stdenv,
  fetchgit,
  gfortran,
  python3,
  hdf5-fortran,
  lapack,
  lapack95,
  odepack,
  autoPatchelfHook,
  pkg-config,
}:
let
  python = python3.withPackages (p: [ p.fypp ]);
  makeFilesToPatch = "src/tide/Makefile src/forum/build/Make.inc src/mesa/Makefile src/math/unit/Makefile src/interp/Makefile build/Make.inc build/Makefile";
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
    rev = "5cc145a0d2abcec7f7cb209a1cda44e6d92fefe2";
    hash = "sha256-LzoW3hInUyjQheLxObg/nltVXvN5/iH8aRMj1PKcJjM=";
  };

  patches = [ ./gyre.patch ];

  CRMATH = "no";
  FFLAGS = [ " -I${hdf5-fortran.dev}/include" " -I${lapack95}/include" " -I${odepack}/include" ];

  nativeBuildInputs = [ autoPatchelfHook gfortran pkg-config ];
  buildInputs = [ hdf5-fortran lapack lapack95 odepack ];

  configurePhase =
  ''
  ${(lib.strings.concatStringsSep "\n" (lib.attrsets.mapAttrsToList (name: value: "sed -i \"s|${name}|${value}|\" ${makeFilesToPatch}") linkProgsToPkgConfig))}
  sed -i "s|#!/usr/bin/env python3|#!${python}/bin/python3|" src/forum/build/fypp_deps build/fypp_deps
  sed -i "s|^sys.path.insert|#sys.path.insert|" src/forum/build/fypp_deps build/fypp_deps
  echo "echo passed" > build/check_sdk_version
  echo "echo passed" > src/forum/build/check_sdk_version
  sed -i "s|NIX_GYRE_DIR|$out|" src/common/constants_m.fypp
  '';

  installPhase =
  ''
  mkdir -p $out/bin
  mkdir -p $out/lib

  cp bin/* $out/bin
  cp lib/*.so $out/lib
  cp -r data $out

  for bin in $out/{bin,lib}/*; do
    patchelf --remove-rpath $bin
  done
  '';
}