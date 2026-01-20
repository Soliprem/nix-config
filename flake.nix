{
  description = "Soli's Nixos Config";

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      pkgs = nixpkgs.legacyPackages.${"x86_64-linux"};
      configRoot = ./.;
    in
    {
      templates = import ./flake-templates;
      nixosConfigurations = {
        nixos-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs configRoot; };
          modules = [
            ./hosts/laptop/configuration.nix
          ];
        };
        nixos-pc = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs configRoot; };
          modules = [
            ./hosts/pc/configuration.nix
          ];
        };
      };

      packages.${pkgs.stdenv.hostPlatform.system} = {
        nvf =
          (inputs.nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [
              ./export/nvf.nix
            ];
          }).neovim;
        nvf-minimal =
          (inputs.nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [
              ./export/nvf-minimal.nix
            ];
          }).neovim;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    thumbpick = {
      url = "github:soliprem/thumbpick";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    subtui = {
      url = "github:mattiapun/subtui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dm-scripts = {
      url = "github:soliprem/dm-scripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    ekphos = {
      url = "github:hanebox/ekphos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nvf-soli.url = "github:soliprem/nvf-soli/";
    nvf.url = "github:notashelf/nvf/";
    # nvf.url = "path:/home/soliprem/.local/src/nvf-maint/";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
