{
  stdenv,
  fetchurl,
  gfortran,
  lapack,
  pkg-config,
}: let
  version = "3.0";
in
  stdenv.mkDerivation {
    inherit version;
    pname = "lapack95";

    src = fetchurl {
      url = "https://www.netlib.org/lapack95/lapack95.tgz";
      hash = "sha256-VXEeWxxd3Jx90dPqFcN/xbQAeDrG6lc6deKxNYwsR5s=";
    };

    nativeBuildInputs = [gfortran pkg-config];
    buildInputs = [lapack];

    configurePhase = ''
      cp ${./lapack95-make.inc} make.inc
    '';

    buildPhase = ''
      pushd SRC
      make single_double_complex_dcomplex
      popd
    '';

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $out/lib/pkgconfig
      mkdir -p $out/include
      
      cp lapack95.* $out/lib
      cp lapack95_modules/* $out/include
      
      cat <<EOF > $out/lib/pkgconfig/lapack95.pc
      Name: lapack95
      Version: ${version}
      Description: LAPACK FORTRAN 95 wrapper
      Cflags: -I$out/include
      Libs: -L$out/lib -l:lapack95.a
      EOF
    '';
  }
