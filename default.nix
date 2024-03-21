{ pkgs ? import <nixpkgs> {}}: with pkgs; {
  gyre-next = callPackage ./gyre-next.nix {
    lapack95 = callPackage ./lapack95.nix {};
    odepack = callPackage ./odepack.nix {};
    hdf5-fortran = hdf5-fortran.overrideAttrs (finalAttrs: prevAttrs: {patches = (prevAttrs.patches or []) ++ [./hdf5.patch];});
    python3 = python3.override {
      packageOverrides = self: super: {fypp = callPackage ./fypp.nix {buildPythonPackage = super.buildPythonPackage;};};
    };
  };
  gyre-71 = callPackage ./gyre.nix {
    lapack95 = callPackage ./lapack95.nix {};
    hdf5-fortran = hdf5-fortran.overrideAttrs (finalAttrs: prevAttrs: {patches = (prevAttrs.patches or []) ++ [./hdf5.patch];});
    fpx3 = callPackage ./fpx3.nix {};
    fpx3_deps = callPackage ./fpx3_deps.nix {};
  };
}
