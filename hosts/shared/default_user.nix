{pkgs, ...}: {
  users.users.soliprem = {
    isNormalUser = true;
    description = "Francesco Prem Solidoro";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
      "plugdev"
    ];
    shell = "${pkgs.busybox}/bin/ash";
  };

  environment.shells = with pkgs; [
    nushell
    busybox
    "${busybox}/bin/ash"
    fish
  ];
}
