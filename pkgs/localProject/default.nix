{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "local-cpp-project";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [pkgs.gcc];

  buildPhase = ''
    mkdir -p $out/bin
    g++ -o $out/bin/local-cpp-project main.cpp
  '';

  installPhase = ''
    ls -lh $out/bin
  '';
}
