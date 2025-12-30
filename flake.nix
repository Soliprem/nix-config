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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    thumbpick.url = "github:soliprem/thumbpick";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    matugen = {
      url = "github:InioX/Matugen";
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

    nvf.url = "github:notashelf/nvf/";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins/";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
