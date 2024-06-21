# home.nix
{
  inputs,
  lib,
  config,
  pkgs,
  ...
  }: {
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    monitor = ",preferred,auto,1";
    input.kb_layout = "eu";
    input.kb_options = "caps:swapescape";
     bind =
      [
        ", Print, exec, grimblast copy area"
        "$mod, E, exec, nautilus --new-window"
        "$mod, w, exec, firefox"
        "$mod, Return, exec, foot"
        "$mod, Q, killactive, "
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
  };

}
