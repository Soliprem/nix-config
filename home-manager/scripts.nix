{pkgs, ...}: let
  wayshotpick = pkgs.writeShellApplication {
    name = "wayshotpick";
    runtimeInputs = with pkgs; [wayshot slurp];
    text = ''
      case "$(printf "a selected area\\nfull screen\\na selected area (copy)\\nfull screen (copy)" |\
        fuzzel --dmenu -l 6 -i -p "Screenshot which area?")" in
          "a selected area") wayshot -s "$(slurp -f '%x %y %w %h')" -f\
            ~/Pictures/wayshot/sel-area-"$(date '+%y%m%d-%H%M-%S').png" ;;
          "full screen") wayshot -f ~/Pictures/wayshot/pic-full-"$(date '+%y%m%d-%H%M-%S').png" ;;
          "a selected area (copy)") wayshot -s "$(slurp -f '%x %y %w %h')" --stdout | wl-copy ;;
          "full screen (copy)") wayshot --stdout | wl-copy ;;
      esac
    '';
  };
in {
  home.packages = [wayshotpick];
}
