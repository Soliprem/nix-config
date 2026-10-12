{inputs, ...}: {
  imports = [inputs.nur.repos.claymorwan.nixosModules.pvpn];
  programs.pvpn = {
    enable = true;
    users = ["soliprem"];
  };
  systemd.services.pvpnd.serviceConfig.ConfigurationDirectory = "pvpn";
}
