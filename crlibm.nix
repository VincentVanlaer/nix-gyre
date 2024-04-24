{
  fetchgit,
  stdenv,
  autoreconfHook,
}: let
  version = "1.0beta5";
in
  stdenv.mkDerivation {
    pname = "crlibm";
    inherit version;

    src = fetchgit {
      url = "https://github.com/taschini/crlibm";
      rev = "eb3063791aa75bc9705b49283bf14250465220a7";
      hash = "sha256-HTiTVVbbSpUHPfYyALoQ6p6CYEOF2SI5GyxFuY1QnDY=";
    };

    nativeBuildInputs = [autoreconfHook];

    postInstall = ''
      mkdir -p $out/lib/pkgconfig

      cat <<EOF > $out/lib/pkgconfig/crlibm.pc
      Name: crlibm
      Version: ${version}
      Description: Correctly rounded math functions
      Libs: -L$out/lib -lcrlibm -lscs
      EOF
    '';
  }
