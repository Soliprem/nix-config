{
  description = "Soli's Nixos Config";

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    nvfPkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (pkgs.lib.getName pkg) ["eyeliner.nvim"];
    };
    configRoot = ./.;
  in {
    templates = import ./flake-templates;
    formatter.${system} = pkgs.alejandra;
    nixosConfigurations = {
      nixos-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs configRoot;};
        modules = [
          ./hosts/laptop/configuration.nix
        ];
      };
      nixos-pc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs configRoot;};
        modules = [
          ./hosts/pc/configuration.nix
        ];
      };
    };

    packages.${pkgs.stdenv.hostPlatform.system} = {
      nvf =
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = nvfPkgs;
          extraSpecialArgs = {
            flakeInputs = inputs;
          };
          modules = [
            ./export/nvf.nix
          ];
        }).neovim;
      nvf-minimal =
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = nvfPkgs;
          extraSpecialArgs = {
            flakeInputs = inputs;
          };
          modules = [
            ./export/nvf-minimal.nix
          ];
        }).neovim;
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    r-nvim = {
      url = "github:R-nvim/R.nvim";
      flake = false;
    };
    neowiki-nvim = {
      url = "github:echaya/neowiki.nvim";
      flake = false;
    };
    sysboard = {
      url = "github:system64fumo/sysboard";
      flake = false;
    };
    remarkable-bridge = {
      url = "github:blwtxc/remarkable-bridge";
      flake = false;
    };
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ferrosonic = {
      url = "github:jaidaken/ferrosonic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    beer = {
      url = "git+https://git.notashelf.dev/notashelf/beer.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stash = {
      url = "github:notashelf/stash";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cade = {
      url = "github:manic-systems/cade";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watt = {
      url = "github:notashelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eh = {
      url = "github:notashelf/eh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    thumbpick = {
      url = "github:soliprem/thumbpick";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    roam-graph = {
      url = "github:soliprem/roam-graph-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tuicr = {
      url = "github:agavra/tuicr";
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

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nvf-soli.url = "github:soliprem/nvf-soli/";
    nvf.url = "github:soliprem/nvf/bin-path";
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nvf.url = "path:/home/soliprem/.local/src/nvf-admin/";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
