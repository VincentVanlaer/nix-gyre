This repository contains all the necessary nix files and patches to run [GYRE](https://github.com/rhtownsend/gyre) on nix-based systems. Currently, only the next-gen branch of GYRE is supported as the build system is easier to use.

To quickly build and get a shell with GYRE, run

```
nix-shell -p '(import (fetchGit { url="https://github.com/VincentVanlaer/nix-gyre"; } ) {}).gyre'
```

This repository also contains build files for:

- fypp (FORTRAN preprocessor, in nixpkgs, but not as importable package)
- lapack95 (FORTRAN95 wrapper for LAPACK)
- odepack

Note that the bit-for-bit reproducible mode with crlibm is not supported currently (it may also be necessary to check that we don't break that in other ways). Another problem is that HDF5 has a [bug](https://github.com/HDFGroup/hdf5/issues/3831) for which the [fix](https://github.com/HDFGroup/hdf5/pull/3837) has not yet been released, so we patch HDF5 here.
