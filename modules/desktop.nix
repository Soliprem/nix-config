{config, ...}: {
  flake.modules.nixos.desktop.imports = with config.flake.modules.nixos; [
    platform
    base
    nix
    hjem
    shells
    terminals
    theme
    desktop-shell
    hyprland
    niri
    mango
    mail
    doom
    neovim
    helix
    networking
    gaming
    audio
    video
    apps
    development
    printing
    flatpak
    remarkable
  ];
}
