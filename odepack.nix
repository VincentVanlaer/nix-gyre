{
  stdenv,
  fetchurl,
  gfortran,
}:
let
  version = "0";
in
stdenv.mkDerivation {
  inherit version;
  name = "odepack";

  src = fetchurl {
    url = "http://user.astro.wisc.edu/~townsend/resource/download/sdk2/src/odepack-omp.tar.gz";
    hash = "sha256-HeNnqoQCkIUTl++6C0X83HfShMiLDqiXdFbspNNJ5qk=";
  };
  
  nativeBuildInputs = [ gfortran ];

  installPhase =
  ''
  mkdir -p $out/lib
  mkdir -p $out/lib/pkgconfig
  mkdir -p $out/include
 
  cp libodepack.a $out/lib
  cp odepack.mod $out/include 

  cat <<EOF > $out/lib/pkgconfig/odepack.pc
Name: lapack95
Version: ${version}
Description: LAPACK FORTRAN 95 wrapper
Cflags: -I$out/include
Libs: -L$out/lib -lodepack
EOF
  '';
}
