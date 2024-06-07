{
  pkgs ? import <nixpkgs> {},
  lapack-netlib ? true,
  crmath ? true,
}: let
  callPackage = pkgs.callPackage;
  hdf5-fortran = pkgs.hdf5-fortran;
  python3 = pkgs.python3;
  gyre-0-versions = {
    gyre-52 = {
      version = "5.2";
      hash = "sha256-IoH5Fh+JVvDJOTzLEB3EBDqOIUfKsH6Gi7Lrg41b1bQ=";
    };
    gyre-51 = {
      version = "5.1";
      hash = "sha256-ki6gsLolKV4DoybMlfSNoLIk4eQ2cnC4v3SVW6LtVPI=";
    };
    gyre-50 = {
      version = "5.0";
      hash = "sha256-JGisEcJUGp4Bht4MCpdSR5sxCOSaPIuuKeTqrIKvYWk=";
    };
  };
  gyre-1-versions = {
    gyre-71 = {
      version = "7.1";
      hash = "sha256-vvY43KBOTYd+iykVyd+7x0kZ+WwTTZoi3l1oWKKCcSM=";
    };
    gyre-70 = {
      version = "7.0";
      hash = "sha256-jUS3AsH4lP/iEIvrPoLlngfLgm5480gd+s9l+kgWa2Q=";
    };
    gyre-60 = {
      version = "6.0.1";
      hash = "sha256-UR5MDN8m2TiS7fd7a39OahLBpA2Fo9I/IkehmYbsRxc=";
    };
  };
  gyre-2-versions = {
    gyre-72 = {
      version = "7.2";
      hash = "sha256-k0DWLJiILaQ6ue5ny9uQCXGm4pUXb667Pa8LIK7Y4HU=";
    };
  };

  crlibm = callPackage ./crlibm.nix {};
  crlibm-fortran = callPackage ./crlibm-fortran.nix {inherit crlibm;};
  lapack =
    if lapack-netlib
    then
      callPackage ./lapack.nix {
        inherit crlibm-fortran;
        withCrlibm = crmath;
      }
    else pkgs.lapack;
  lapack95 = callPackage ./lapack95.nix {inherit lapack;};
  odepack = callPackage ./odepack.nix {};
  hdf5 = hdf5-fortran.overrideAttrs (finalAttrs: prevAttrs: {patches = (prevAttrs.patches or []) ++ [./hdf5.patch];});
  python3-with-fypp = python3.override {
    packageOverrides = self: super: {fypp = callPackage ./fypp.nix {buildPythonPackage = super.buildPythonPackage;};};
  };
  fpx3 = callPackage ./fpx3.nix {};
  fpx3_deps = callPackage ./fpx3_deps.nix {};
in
  builtins.mapAttrs (name: g:
    callPackage (import ./gyre-2.nix g) {
      inherit lapack lapack95 odepack crlibm-fortran;
      hdf5-fortran = hdf5;
      python3 = python3-with-fypp;
      withCrlibm = crmath;
    })
  gyre-2-versions
  // builtins.mapAttrs (name: g:
    callPackage (import ./gyre-1.nix g) {
      inherit lapack lapack95 fpx3 fpx3_deps crlibm-fortran;
      hdf5-fortran = hdf5;
      withCrlibm = crmath;
    })
  gyre-1-versions
  // builtins.mapAttrs (name: g:
    callPackage (import ./gyre-0.nix g) {
      inherit lapack lapack95 fpx3 fpx3_deps crlibm-fortran;
      hdf5-fortran = hdf5;
      withCrlibm = crmath;
    })
  gyre-0-versions
