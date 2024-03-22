{
  version,
  hash,
}:
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
  helpers = (import ./helpers.nix { inherit lib; });
  makeFiles = "src/tide/Makefile src/mesa/Makefile src/build/Make.inc src/build/Makefile";
  linkProgs = {
    "mesasdk_hdf5_link" = "pkg-config --libs hdf5_fortran";
    "mesasdk_lapack95_link" = "pkg-config --libs lapack95 lapack";
    "mesasdk_odepack_link" = "pkg-config --libs odepack";
  };
in
  stdenv.mkDerivation {
    pname = "gyre";
    inherit version;

    src = fetchgit {
      url = "https://github.com/rhdtownsend/gyre";
      rev = "v${version}";
      inherit hash;
    };

    patches = [./gyre.patch];

    CRMATH = "no";
    FFLAGS = [" -I${hdf5-fortran.dev}/include" " -I${lapack95}/include"];

    nativeBuildInputs = [gfortran pkg-config fpx3 fpx3_deps];
    buildInputs = [hdf5-fortran lapack lapack95];

    configurePhase = ''
      ${helpers.patchLinkProgs makeFiles linkProgs}
      echo "echo passed" > src/build/check_sdk_version
      sed -i "s|NIX_GYRE_DIR|$out|" src/common/gyre_constants.fpp
    '';

    installPhase = ''
      mkdir -p $out/bin

      cp bin/* $out/bin
      cp -r data $out
    '';
  }
