{
  pkgs,
  inputs,
  system,
  ...
}: {
  default = pkgs.mkShellNoCC {
    name = "Example Dev Shell";
    meta.description = ''
      Metadata for the shell
    '';

    # Set up pre-commit hooks when user enters the shell.
    shellHook = ''
      echo hi
      LD_LIBRARY_PATH=${pkgs.gcc.cc.lib}/lib/
    '';

    # This is an example of setting an environment variable.
    MY_ENV_VARIABLE = "test";

    packages = with pkgs;
      [
        jdk
        opencv
        # ruby
        # cargo

        (python3.withPackages (python-pkgs: [
          python-pkgs.pandas
          python-pkgs.requests
        ]))

        (graphviz.override
          {
            # disable xorg support
            withXorg = false;
          })
      ]
      ++ [
        inputs.old-python.legacyPackages.${system}.python27
      ];
  };
}
