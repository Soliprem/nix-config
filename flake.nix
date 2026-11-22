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
    material-shell = {
      url = "github:Soliprem/material-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bootvine = {
      url = "git+https://codeberg.org/wvhulle/bootvine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sable = {
      url = "git+https://git.sable.moe/SableClient/sable-next";
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
    hex = {
      url = "github:anomalyco/hex";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sysboard = {
      url = "github:system64fumo/sysboard";
      flake = false;
    };
    remarkable-bridge = {
      url = "github:blwtxc/remarkable-bridge";
      flake = false;
    };
    # bridgev2 module from NickCao's unmerged nixpkgs branch
    mautrix-telegram-module = {
      url = "file+https://raw.githubusercontent.com/NickCao/nixpkgs/50c68a69fd579c02983e642044023bb2226dc6fd/nixos/modules/services/matrix/mautrix-telegram.nix";
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
    collegio-di-sangue = {
      url = "git+ssh://git@git.soliprem.eu:33/soliprem/collegio-di-sangue.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cade = {
      url = "github:manic-systems/cade";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwm = {
      url = "github:bbenne10/river_kwm_modules_nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eh = {
      url = "github:notashelf/eh/";
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
