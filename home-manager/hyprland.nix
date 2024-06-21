{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
  "$mod" = "SUPER"
  bind = 
  [
  "$mod, W, exec, firefox"
  "$mod, d, fuzzel-run"
  ]
  ++ (
  # workspaces
  bultins.concatLIsts (builtins.genLIst (
  x: let
  ws = let
  c = (x+1)/10;
  in
  builtins.toString (x + 1 - (x * 10));
    in [
    "$mod, ${ws}, workspace, ${toString (x + 1)}"
    "$mod SHIFT, ${ws}, workspace, ${toString (x + 1)}"
    ]
  ) 
  10 )
  );
  };

home.pointerCursor = {
  gtk.enable = true;
  # x11.enable = true;
  package = pkgs.bibata-cursors;
  name = "Bibata-Modern-Classic";
  size = 16;
};

gtk = {
  enable = true;
  theme = {
    package = pkgs.flat-remix-gtk;
    name = "Flat-Remix-GTK-Grey-Darkest";
  };

  iconTheme = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
  };

  font = {
    name = "Sans";
    size = 11;
  };
};
}
