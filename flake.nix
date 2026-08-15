{
  description = "Soli's Nixos Config";

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    doomPkgs = pkgs.extend inputs.nix-doom-emacs-unstraightened.overlays.default;
    isyncOauth = pkgs.callPackage ./packages/isync-oauth.nix {};
    nvfPkgs = import inputs.nvf.inputs.nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (inputs.nvf.inputs.nixpkgs.lib.getName pkg) ["eyeliner.nvim"];
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
      nixos-server = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs configRoot;};
        modules = [
          ./hosts/server/configuration.nix
        ];
      };
    };

    deploy.nodes.nixos-server = {
      hostname = "49.12.104.79";
      sshUser = "root";
      autoRollback = true;
      magicRollback = true;
      activationTimeout = 600;
      confirmTimeout = 60;
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.nixos-server;
      };
    };

    checks = builtins.mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

    packages.${pkgs.stdenv.hostPlatform.system} = rec {
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
      foundry-vtt = pkgs.callPackage ./packages/foundry-vtt.nix {};
      iocaine = pkgs.callPackage ./packages/iocaine.nix {};
      isync-oauth = isyncOauth;
      doom-emacs = doomPkgs.emacsWithDoom {
        doomDir = ./doom;
        doomLocalDir = "~/.local/share/nix-doom";
        extraPackages = epkgs: [
          (epkgs.treesit-grammars.with-grammars (grammars: [
            grammars.tree-sitter-typst
          ]))
        ];
        extraBinPackages = with doomPkgs; [
          fd
          git
          isyncOauth
          msmtp
          oama
          ripgrep
          tinymist
          typst
        ];
      };
      default = nvf;
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sable-nightly = {
      # Upstream updates this package after publishing each nightly binary.  It
      # pins the release URL and checksum together, so updating the flake input
      # never requires changing dependency hashes in this repository.
      url = "git+https://aur.archlinux.org/sable-nightly-bin.git?ref=master";
      flake = false;
    };

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
    cade = {
      url = "github:manic-systems/cade";
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
    # nvf.url = "path:/home/soliprem/.local/src/nvf-admin/";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
