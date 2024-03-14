{ pkgs ? import <nixpkgs> {}}: with pkgs; {
  gyre = callPackage ./gyre.nix {
    lapack95 = callPackage ./lapack95.nix {};
    odepack = callPackage ./odepack.nix {};
    hdf5-fortran = hdf5-fortran.overrideAttrs (finalAttrs: prevAttrs: {patches = (prevAttrs.patches or []) ++ [./hdf5.patch];});
    python3 = python3.override {
      packageOverrides = self: super: {fypp = callPackage ./fypp.nix {buildPythonPackage = super.buildPythonPackage;};};
    };
  };
}
