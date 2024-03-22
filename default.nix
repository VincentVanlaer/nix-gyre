{ pkgs ? import <nixpkgs> {}}: let
  callPackage = pkgs.callPackage;
  hdf5-fortran = pkgs.hdf5-fortran;
  python3 = pkgs.python3;
in rec {
  lapack95 = callPackage ./lapack95.nix {};
  odepack = callPackage ./odepack.nix {};
  hdf5 = hdf5-fortran.overrideAttrs (finalAttrs: prevAttrs: {patches = (prevAttrs.patches or []) ++ [./hdf5.patch];});
  python3-with-fypp = python3.override {
    packageOverrides = self: super: {fypp = callPackage ./fypp.nix {buildPythonPackage = super.buildPythonPackage;};};
  };
  fpx3 = callPackage ./fpx3.nix {};
  fpx3_deps = callPackage ./fpx3_deps.nix {};

  gyre-next = callPackage ./gyre-next.nix {
    inherit lapack95 odepack;
    hdf5-fortran = hdf5;
    python3 = python3-with-fypp;
  };
  gyre-71 = callPackage ./gyre.nix {
    inherit lapack95 fpx3 fpx3_deps;
    hdf5-fortran = hdf5;
  };
}
