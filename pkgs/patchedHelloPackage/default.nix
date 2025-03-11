{pkgs}:
pkgs.hello-cpp.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or []) ++ [./hello.patch];
})
