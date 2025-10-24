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
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-user-session --time --cmd mango";
        user = "soliprem";
      };
    };
  };
}
