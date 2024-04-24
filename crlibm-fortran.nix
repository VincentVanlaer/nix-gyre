{
  stdenv,
  gfortran,
  fetchgit,
  crlibm,
}: let
  version = "1.1";
in
  stdenv.mkDerivation {
    pname = "crlibm-fortran";
    inherit version;

    src = fetchgit {
      url = "https://github.com/rhdtownsend/crmath";
      rev = "62822222b94810dd9601a4076a6ca36a20211bff";
      hash = "sha256-JAdDURvFLZtPMWTZ9jyxSzhhlYuwc/y//IYNOvmi948=";
    };

    nativeBuildInputs = [gfortran];
    propagatedBuildInputs = [crlibm];

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $out/lib/pkgconfig
      mkdir -p $out/include
      cp libcrmath.a $out/lib
      cp crmath.mod *.smod  $out/include

      cat <<EOF > $out/lib/pkgconfig/crlibm-fortran.pc
      Name: crlibm-fortran
      Version: ${version}
      Requires: crlibm
      Description: FORTRAN bindings for crlibm
      Cflags: -I$out/include
      Libs: -L$out/lib -lcrmath
      EOF
    '';
  }
