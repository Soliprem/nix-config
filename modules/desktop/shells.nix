{
  flake.modules.nixos.desktop-shell = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.desktopShell;
    hooks = pkgs.linkFarm "desktop-shell-hooks" (lib.concatLists (lib.mapAttrsToList (name: profile:
      lib.mapAttrsToList (action: text: {
        name = "${name}/${action}";
        path = lib.getExe (pkgs.writeShellApplication {
          name = "rice-${name}-${action}";
          runtimeInputs = with pkgs; [coreutils systemd];
          inherit text;
        });
      }) ({inherit (profile) on off available;} // profile.actions))
    cfg.profiles));
    switcher = pkgs.writeShellApplication {
      name = "rice-style";
      runtimeInputs = with pkgs; [coreutils systemd util-linux];
      runtimeEnv = {
        NIXRICE_SHELLS = hooks;
        NIXRICE_DEFAULT_SHELL = cfg.default;
      };
      text = builtins.readFile ../../scripts/rice-style.sh;
    };
  in {
    options.desktopShell = {
      default = lib.mkOption {
        type = lib.types.str;
        default = "noctalia";
        description = "Shell selected before a runtime choice has been saved.";
      };
      profiles = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            on = lib.mkOption {
              type = lib.types.lines;
              description = "Commands that activate this shell.";
            };
            off = lib.mkOption {
              type = lib.types.lines;
              description = "Commands that deactivate this shell.";
            };
            available = lib.mkOption {
              type = lib.types.lines;
              default = "true";
              description = "Command whose exit status determines availability in this session.";
            };
            actions = lib.mkOption {
              type = lib.types.attrsOf lib.types.lines;
              default = {};
              description = "Shell controls dispatched by rice-style action.";
            };
          };
        });
        description = "Installed shells and their activation hooks.";
      };
    };
    config.environment.systemPackages = [
      switcher
      (pkgs.writeShellApplication {
        name = "rice-lock";
        runtimeInputs = [switcher];
        text = ''exec rice-style action lock "$@"'';
      })
    ];
  };
}
