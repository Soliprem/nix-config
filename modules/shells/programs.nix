{inputs, ...}: {
  flake.modules.nixos.shells = {pkgs, ...}: {
    programs = {
      eh = {
        enable = true;
        comma.enable = true;
      };
      cade = {
        enable = true;
        direnvCompat = "full";
      };
      gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-all;
      };
    };
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings = {
          global.overload_tap_timeout = 200;
          main = {
            altgr = "overload(altgr, capslock)";
            capslock = "overload(control,esc)";
            leftshift = "overload(shift, S-9)";
            rightshift = "overload(shift, S-0)";
          };
        };
      };
    };
    imports = [
      inputs.eh.nixosModules.default

      inputs.cade.nixosModules.default
    ];
    environment.systemPackages = with pkgs; [
      gnupg
      atuin
      bat
      btop-rocm
      carapace
      cowsay
      eza
      fd
      fortune
      fzf
      killall
      lazygit
      nix-your-shell
      ripgrep
      scarab
      tealdeer
      termdown
      timer
      udict
      wget
      wiki-tui
      zoxide
      gh
      _7zz-rar
    ];
  };
}
