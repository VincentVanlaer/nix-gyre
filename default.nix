{
  pkgs ? import <nixpkgs> {},
  lapack-netlib ? true,
}: let
  callPackage = pkgs.callPackage;
  hdf5-fortran = pkgs.hdf5-fortran;
  python3 = pkgs.python3;
  gyre-0-versions = {
    gyre-52 = { version = "5.2"; hash = "sha256-IoH5Fh+JVvDJOTzLEB3EBDqOIUfKsH6Gi7Lrg41b1bQ="; };
    gyre-51 = { version = "5.1"; hash = "sha256-ki6gsLolKV4DoybMlfSNoLIk4eQ2cnC4v3SVW6LtVPI="; };
    gyre-50 = { version = "5.0"; hash = "sha256-JGisEcJUGp4Bht4MCpdSR5sxCOSaPIuuKeTqrIKvYWk="; };
  };
  gyre-1-versions = {
    gyre-71 = { version = "7.1"; hash = "sha256-vvY43KBOTYd+iykVyd+7x0kZ+WwTTZoi3l1oWKKCcSM="; };
    gyre-70 = { version = "7.0"; hash = "sha256-jUS3AsH4lP/iEIvrPoLlngfLgm5480gd+s9l+kgWa2Q="; };
    gyre-60 = { version = "6.0.1"; hash = "sha256-UR5MDN8m2TiS7fd7a39OahLBpA2Fo9I/IkehmYbsRxc="; };
  };

  lapack = if lapack-netlib then callPackage ./lapack.nix {} else pkgs.lapack;
  lapack95 = callPackage ./lapack95.nix { lapack = lapack; };
  odepack = callPackage ./odepack.nix {};
  hdf5 = hdf5-fortran.overrideAttrs (finalAttrs: prevAttrs: {patches = (prevAttrs.patches or []) ++ [./hdf5.patch];});
  python3-with-fypp = python3.override {
    packageOverrides = self: super: {fypp = callPackage ./fypp.nix {buildPythonPackage = super.buildPythonPackage;};};
  };
  fpx3 = callPackage ./fpx3.nix {};
  fpx3_deps = callPackage ./fpx3_deps.nix {};
in {
  gyre-next = callPackage ./gyre-2.nix {
    inherit lapack lapack95 odepack;
    hdf5-fortran = hdf5;
    python3 = python3-with-fypp;
  };
} // builtins.mapAttrs (name: g: callPackage (import ./gyre-1.nix g) {
    inherit lapack lapack95 fpx3 fpx3_deps;
    hdf5-fortran = hdf5;
  }) gyre-1-versions
 // builtins.mapAttrs (name: g: callPackage (import ./gyre-0.nix g) {
    inherit lapack lapack95 fpx3 fpx3_deps;
    hdf5-fortran = hdf5;
  }) gyre-0-versions
