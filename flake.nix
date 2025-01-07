{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    agenix.url = "github:ryantm/agenix";
    diniamo.url = "github:diniamo/nixpkgs/custom";
    sash.url = "github:soliprem/sash";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    matugen.url = "github:InioX/Matugen";
    ghostty.url = "github:ghostty-org/ghostty";
    astal = {
      url = "github:Aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };
    # nixpkgs.follows = "nixos-cosmic/nixpkgs";
    soluastal.url = "github:soliprem/soluastal";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixpkgs.url = "github:NixOS/nixpkgs/b79ce4c43f9117b2912e7dbc68ccae4539259dda";
    walker.url = "github:abenz1267/walker";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    soniksnvim.url = "github:Soliprem/soniksnvim";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    # pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };
    iio-hyprland.url = "github:JeanSchoeller/iio-hyprland";
    stylix.url = "github:danth/stylix";
    # stylix.url = "github:Soliprem/stylix/patch-1";
    # Neovimflake
    norg-meta.url = "github:nvim-neorg/tree-sitter-norg-meta";
    nvf.url = "github:notashelf/nvf/";
    # nvf.url = "github:soliprem/nvf/add-nu";
    # nvf.url = "/home/soliprem/.local/src/nvf/";
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    # Hyprspace = {
    #   url = "github:KZDKM/Hyprspace";
    #
    #   # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
    #   inputs.nixpkgs.follows = "nixpkgs";
    # }; #   };
    # schizofox = {
    #   url = "github:schizofox/schizofox";
    #   };
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    # hyprland,
    stylix,
    spicetify-nix,
    home-manager,
    lix-module,
    nixos-cosmic,
    # pipewire-screenaudio,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      nixos-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          ./hosts/laptop/configuration.nix
          lix-module.nixosModules.default
          ./system/ollama.nix
          ./system/default.nix
          nixos-cosmic.nixosModules.default
        ];
      };
      nixos-pc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          ./hosts/pc/configuration.nix
          lix-module.nixosModules.default
          ./system/ollamaRocm.nix
          # ./system/ollama.nix
          ./system/default.nix
          nixos-cosmic.nixosModules.default
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "soliprem@nixos-laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/home.nix
          nvf.homeManagerModules.default
          stylix.homeManagerModules.stylix
          spicetify-nix.homeManagerModules.default
          # hyprland.homeManagerModules.default
        ];
      };
      "soliprem@nixos-pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/home.nix
          nvf.homeManagerModules.default
          stylix.homeManagerModules.stylix
          spicetify-nix.homeManagerModules.default
          # hyprland.homeManagerModules.default
        ];
      };
    };
  };
}
