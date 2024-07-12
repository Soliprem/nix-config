{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    erosanix.url = "github:emmanuelrosa/erosanix";
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0-rc1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    iio-hyprland.url = "github:JeanSchoeller/iio-hyprland";
    stylix.url = "github:danth/stylix";
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      # url = "github:ReshetnikovPavel/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    hycov = {
      url = "github:DreamMaoMao/hycov";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    # Neovimflake
    nvf.url = "github:notashelf/nvf";
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    schizofox = {
      url = "github:schizofox/schizofox";
    };
    muse-sounds-manager.url = "github:thilobillerbeck/muse-sounds-manager-nix";
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    hyprland,
    stylix,
    home-manager,
    lix-module,
    erosanix,
    muse-sounds-manager,
    pipewire-screenaudio,
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
          ./nixos/laptop/configuration.nix
          lix-module.nixosModules.default
          ./system/ollama.nix
        ];
      };
      nixos-pc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          ./nixos/pc/configuration.nix
          lix-module.nixosModules.default
          erosanix.systemPackages.x86_64-linux.protonvpn
          # ./system/ollamaRocm.nix
          ./system/protonvpn.nix
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
          hyprland.homeManagerModules.default
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
          hyprland.homeManagerModules.default
        ];
      };
    };
  };
}
