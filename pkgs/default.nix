# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) callPackage;

  layered-image = pkgs.dockerTools.buildLayeredImage {
    name = "layered-image";
    tag = "latest";
    extraCommands = ''echo "(extraCommand)" > extraCommands'';
    config.Cmd = ["${pkgs.hello}/bin/hello"];
    contents = [
      pkgs.hello
      pkgs.bash
      pkgs.coreutils
    ];
  };
in {
  # example = pkgs.callPackage ./example { };
  hello = pkgs.hello-cpp;
  mqtt =
    pkgs.mosquitto.overrideAttrs
    (old: {
      cmakeFlags =
        old.cmakeFlags
        ++ ["-DWITH_WEBSOCKETS=ON"];
      version = "2.0.13";
      # pkgs.fetchgit
      src = pkgs.fetchFromGitHub {
        owner = "eclipse";
        repo = "mosquitto";
        rev = "v2.0.13";
        sha256 = "sha256-Nnt4NCxMTNe5FCzW3hHtQG27jyn3mM6ZQCgQO/wbolc=";
      };
    });
  patchedHello = callPackage ./patchedHelloPackage {inherit pkgs;};
  localProject = callPackage ./localProject {inherit pkgs;};
  shellScript = callPackage ./shellScript {inherit pkgs;};

  dockerExample = callPackage ./dockerExample {inherit pkgs lib;};
  # more examples
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/docker/examples.nix
  # documentation
  # https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools

  # 10. Create a layered image
  inherit layered-image;
  # 11. Create an image on top of a layered image
  layered-on-top = pkgs.dockerTools.buildImage {
    name = "layered-on-top";
    tag = "latest";
    fromImage = layered-image;
    extraCommands = ''
      mkdir ./example-output
      chmod 777 ./example-output
    '';
    config = {
      Env = ["PATH=${pkgs.coreutils}/bin/"];
      WorkingDir = "/example-output";
      Cmd = [
        "${pkgs.bash}/bin/bash"
        "-c"
        "echo hello > foo; cat foo"
      ];
    };
  };

  dockerToolsExample = pkgs.dockerTools.buildLayeredImage {
    name = "go-app";
    tag = "latest";
    contents = [pkgs.go];
    config = {
      Cmd = ["${pkgs.go}/bin/go"];
    };
  };
}
