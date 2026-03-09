{
  pkgs ? import <nixpkgs> { },
}:
with pkgs;
mkShell {

  buildInputs = [
    (import ./build.nix { inherit pkgs; })
  ];

  shellHook = ''

  '';

  packages = [

  ];
}
