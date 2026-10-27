{
  description = "Soli's Nixos Config";
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];
    };

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Temporary until the Audacity/MuseScore Qt fixes reach nixos-unstable and its cache.
    nixpkgs-audio.url = "github:nixos/nixpkgs/c59305bab2065cfecc4944690d9eedbb56f3a9fa";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cyberarch = {
      url = "github:ARCANGEL0/cyberarch-dotfiles/";
      flake = false;
    };
    material-shell = {
      url = "github:Soliprem/material-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    amethyst-mod-manager = {
      url = "github:ChrisDKN/Amethyst-Mod-Manager/";
      inputs.nixpkgs.follows = "nixpkgs";
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
    brewery = {
      url = "git+ssh://git@git.notashelf.dev:33/notashelf/brewery.git";
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
