{
  description = "slidev-slides";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: 
      let 
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        formatter = pkgs.nixpkgs-fmt;
        flakedPkgs = pkgs;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_20 corepack_20 python311
          ];
        };
      }
    );
}
