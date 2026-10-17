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
      activationTimeout = 600;
      confirmTimeout = 60;
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.nixos-server;
      };
    };

    packages.${pkgs.stdenv.hostPlatform.system} = rec {
      cyberarch-shell = pkgs.callPackage ./packages/cyberarch-shell.nix {
        src = inputs.cyberarch;
      };
      cyberarch-fonts = cyberarch-shell;
      amethyst-mod-manager = pkgs.callPackage ./packages/amethyst-mod-manager.nix {
        src = inputs.amethyst-mod-manager;
        liblootSrc = inputs.amethyst-libloot;
      };
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
      isync-oauth = isyncOauth;
      doom-emacs = doomPkgs.emacsWithDoom {
        emacs = doomPkgs.emacs-pgtk;
        doomDir = ./doom;
        doomLocalDir = "~/.local/share/nix-doom";
        emacsPackageOverrides = _: epkgs: {
          julia-snail = epkgs.julia-snail.overrideAttrs (old: {
            postPatch =
              (old.postPatch or "")
              + ''
                      cat >> extensions/formatter/Project.toml <<'EOF'

                [compat]
                JuliaFormatter = "=1.0.62"
                EOF
              '';
          });
        };
        extraPackages = epkgs: [
          (epkgs.treesit-grammars.with-grammars (grammars: [
            grammars.tree-sitter-typst
            # julia-ts-mode's queries target grammar v0.23.1.
            (grammars.tree-sitter-julia.override {
              version = "0.23.1";
              src = doomPkgs.fetchFromGitHub {
                owner = "tree-sitter";
                repo = "tree-sitter-julia";
                rev = "v0.23.1";
                hash = "sha256-jwtMgHYSa9/kcsqyEUBrxC+U955zFZHVQ4N4iogiIHY=";
              };
            })
          ]))
        ];
        extraBinPackages = with doomPkgs; [
          fd
          git
          isyncOauth
          (mpv.override {scripts = [mpvScripts.mpris];})
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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cyberarch = {
      url = "github:ARCANGEL0/cyberarch-dotfiles/";
      flake = false;
    };
    amethyst-mod-manager = {
      url = "github:ChrisDKN/Amethyst-Mod-Manager/v2.4.0";
      flake = false;
    };
    amethyst-libloot = {
      url = "github:loot/libloot/0.29.6";
      flake = false;
    };
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
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
    beer = {
      url = "git+https://git.notashelf.dev/notashelf/beer.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cade = {
      url = "github:manic-systems/cade";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eh = {
      url = "github:notashelf/eh/notashelf/push-sqworykzvvsw";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    thumbpick = {
      url = "github:soliprem/thumbpick";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pager = {
      url = "git+ssh://git@github.com/soliprem/pager.git?ref=main";
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
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silksong-aa = {
      url = "github:Soliprem/silkgsong-journal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
