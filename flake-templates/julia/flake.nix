{
  description = "devFlake for Julia";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system} = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (julia.withPackages ["Plots"])
        ];
        shellHook = ''
          export JULIA_PROJECT="."
        '';
      };
    };
  };
}
