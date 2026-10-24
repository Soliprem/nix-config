{inputs, ...}: {
  flake.modules.nixos.shells = {
    lib,
    pkgs,
    system,
    ...
  }: {
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
        pinentryPackage = lib.mkDefault pkgs.pinentry-curses;
      };
    };
    age.secrets = {
      bitwarden_clientid = {
        file = ../../secrets/bitwarden_clientid.age;
        owner = "soliprem";
      };
      bitwarden_clientsecret = {
        file = ../../secrets/bitwarden_clientsecret.age;
        owner = "soliprem";
      };
      bitwarden_password = {
        file = ../../secrets/bitwarden_password.age;
        owner = "soliprem";
      };
    };
    imports = [
      inputs.eh.nixosModules.default

      inputs.cade.nixosModules.default
    ];
    environment.systemPackages = with pkgs; [
      inputs.deploy-rs.packages.${system}.default
      (pkgs.writeShellApplication {
        name = "greeting";
        runtimeInputs = with pkgs; [
          coreutils
          gawk
          ncurses
          microfetch
          dotacat
        ];
        text = builtins.readFile ../../scripts/greeting.sh;
      })
      (pkgs.writeShellApplication {
        name = "bw-export-session";
        runtimeInputs = with pkgs; [
          bitwarden-cli
          coreutils
        ];
        text = builtins.readFile ../../scripts/bw-export-session.sh;
      })
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
