{
  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    optimise.automatic = true;
  };
}
