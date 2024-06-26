This repository contains all the necessary nix files and patches to run [GYRE](https://github.com/rhtownsend/gyre) on nix-based systems.

To quickly build and get a shell with GYRE 7.1, run

```
nix-shell -p '(import (fetchGit { url="https://github.com/VincentVanlaer/nix-gyre"; } ) {}).gyre-71'
```

Other versions of GYRE can be built by changing the `gyre-71` attribute in the previous command.

This repository also contains build files for:

- fypp (FORTRAN preprocessor, in nixpkgs, but not as importable package)
- fpx3 (FORTRAN preprocessor, used for GYRE version <= 7.1)
- lapack (netlib version of lapack for reproducibility)
- lapack95 (FORTRAN95 wrapper for LAPACK)
- odepack

Currently, HDF5 has a [bug](https://github.com/HDFGroup/hdf5/issues/3831) for which the [fix](https://github.com/HDFGroup/hdf5/pull/3837) has not yet been released, so we patch HDF5 here.
