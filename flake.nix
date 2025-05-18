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
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    astal = {
      url = "github:Aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };
    # nixpkgs.follows = "nixos-cosmic/nixpkgs";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # umu = {
    #   url = "github:Open-Wine-Components/umu-launcher/";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
    # Neovimflake
    norg-meta.url = "github:nvim-neorg/tree-sitter-norg-meta";
    nvf.url = "github:notashelf/nvf/";
    nvf-soli.url = "github:soliprem/nvf-soli";
    # nvf.url = "github:soliprem/nvf/add-nu";
    # nvf.url = "/home/soliprem/.local/src/nvf/";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland.url = "github:UjinT34/Hyprland/simple-cm";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";

      # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
      inputs.nixpkgs.follows = "nixpkgs";
    }; #   };
    # schizofox = {
    #   url = "github:schizofox/schizofox";
    #   };
  };

  outputs = {
    self,
    nixpkgs,
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
          ./system/modules/ollama.nix
          ./system
          ./hjem
        ];
      };
      nixos-pc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          ./hosts/pc/configuration.nix
          ./system/modules/ollamaRocm.nix
          ./system
          ./hjem
        ];
      };
    };
  };
}
