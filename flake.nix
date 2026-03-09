{
  description = "Terminal phone";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        terminalphone = import ./build.nix { inherit pkgs; };
      in
      {
        packages.default = terminalphone;

        apps.default = {
          type = "app";
          program = "${terminalphone}/bin/terminalphone.sh";
        };
      }
    );
}
