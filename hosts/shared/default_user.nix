{pkgs, ...}: {
  users.users.soliprem = {
    isNormalUser = true;
    description = "Francesco Prem Solidoro";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.nushell;
  };
}
