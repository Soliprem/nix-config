{
  description = "OCaml project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    ocamlPackages = pkgs.ocamlPackages;
    package = ocamlPackages.buildDunePackage {
      pname = "project";
      version = "0.1.0";
      src = ./.;
      buildInputs = with ocamlPackages; [
      ];
    };
  in {
    packages.${system}.default = package;

    devShells.${system}.default = pkgs.mkShell {
      inputsFrom = [package];
      packages = with ocamlPackages; [
        ocaml-lsp
        ocamlformat
        utop
      ];
    };
  };
}
