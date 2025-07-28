_:{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            # Space Cadet: tap shift for parentheses, hold for shift
            leftshift = "overload(shift, S-9)";   # S-9 produces (
            rightshift = "overload(shift, S-0)";  # S-0 produces )
          };
        };
      };
    };
  };
}
