# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  hello = pkgs.hello-cpp;
  patchedHello = import ./patchedHelloPackage {inherit pkgs;};
  localProject = import ./localProject {inherit pkgs;};
}
