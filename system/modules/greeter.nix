{ pkgs, ... }:
{
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ../../assets/noise_void.png;
        fit = "Cover";
      };
    };
    theme = {
      name = "chicago95";
      package = pkgs.chicago95;
    };
    font = {
      name = "Fira Code";
    };
  };
}
