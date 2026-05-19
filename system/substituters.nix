{
  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://nyx.cachix.org"
        "https://soliprem.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nyx.cachix.org-1:xH6G0MO9PrpeGe7mHBtj1WbNzmnXr7jId2mCiq6hipE="
        "soliprem.cachix.org-1:kwxQ2xmtoQJVrKUBvSkG/+03ZTuxn06Aebh8AZvtMPA="
      ];
    };
    optimise.automatic = true;
  };
}
