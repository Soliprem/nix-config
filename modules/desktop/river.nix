{
  flake.modules.nixos.river = {
    pkgs,
    inputs,
    ...
  }: {
    programs.river-classic = {
      enable = true;
      package = pkgs.river;
      extraPackages = [inputs.kwm.packages.${system}.default];
    };
    hjem.users.soliprem.files = {
      ".config/kwm/config.zon".text =
        /*
        zon
        */
        ''
        '';
    };
  };
}
