with import <nixpkgs> {
  overlays = [
    (self: super: {hdf5 = super.hdf5.overrideAttrs (finalAttrs: prevAttrs: {patches = (prevAttrs.patches or []) ++ [./hdf5.patch];});})
  ];
}; {
  gyre = callPackage ./gyre.nix {
    lapack95 = callPackage ./lapack95.nix {};
    odepack = callPackage ./odepack.nix {};
    python3 = python3.override {
      packageOverrides = self: super: {fypp = callPackage ./fypp.nix {buildPythonPackage = super.buildPythonPackage;};};
    };
  };
}
