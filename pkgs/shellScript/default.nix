{pkgs, ...}:
pkgs.writeShellScriptBin "thisIsAScript" ''
  echo ${builtins.readFile ./text.txt}

  ${pkgs.cowsay}/bin/cowsay "Hello, this is cowsay speaking!"
''
