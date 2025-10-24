{pkgs, ...}: {
  programs.regreet = {
    enable = false;
    settings = {
      background.path = ../../assets/bg;
    };
      theme.name = "matugen";
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
}
