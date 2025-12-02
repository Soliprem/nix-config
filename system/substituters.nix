{
  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://cosmic.cachix.org/"
        "https://tola.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "tola.cachix.org-1:5hMwVpNfWcOlq0MyYuU9QOoNr6bRcRzXBMt/Ua2NbgA="
      ];
    };
    optimise.automatic = true;
  };
}
