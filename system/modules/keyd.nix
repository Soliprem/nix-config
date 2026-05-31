_: {
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          global.overload_tap_timeout = 200;
          main = {
            control = "overload(control, capslock)";
            capslock = "overload(control,esc)";
            leftshift = "overload(shift, S-9)";
            rightshift = "overload(shift, S-0)";
          };
        };
      };
    };
  };
}
