_:{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          global.overload_tap_timeout = 200;
          main = {
            leftshift = "overload(shift, S-9)";
            rightshift = "overload(shift, S-0)";
            capslock = "overload(control,esc)";
            "control+esc" = "capslock";
          };
        };
      };
    };
  };
}
