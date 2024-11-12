{
  lib,
  pkgs,
  ...
}: let
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
  dm-expand =
    pkgs.writers.writeNuBin "dm-expand" {
      makeWrapperArgs = [
        "--prefix"
        "ATH"
        ":"
        "${lib.makeBinPath [pkgs.fuzzel]}"
      ];
    }
    ''
      let expansions = [
      [key value];
      ["mdash" —]
      ["name" "Francesco Prem Solidoro"]
      ["sign" "Kindest Regards,\nFrancesco Prem Solidoro"]
      ]
      let chosen_key = $expansions.key | to text | fuzzel --dmenu
      wtype ($expansions | where key == $chosen_key | get value.0)
    '';
in {
  home.packages = [wayshotpick dm-expand];
}
