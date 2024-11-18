{
  lib,
  pkgs,
  ...
}: let
  scripts = [
    (
      pkgs.writers.writeNuBin "nixrice" {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [pkgs.waypaper pkgs.swww]}"
        ];
      }
      ''
        let path_list = waypaper | parse "Selected image path: {path}" | get path
        let path = $path_list | last
        wallpaper-to-rice-nix $path
      ''
    )

    (pkgs.writers.writeNuBin "dm-expand" {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
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
      '')

    (pkgs.writeShellApplication {
      name = "wallpaper-to-rice-nix";
      runtimeInputs = with pkgs; [yad libnotify];
      text = ''
        if [[ ''${1:-} ]]; then
        	wallpaper="$1"
        else
        	cd "$HOME"/Pictures/wallpapers || return 1
        	wallpaper="$(yad --width 1200 --height 800 --file --add-preview --large-preview --title='Choose wallpaper')"
        fi

        if [[ $wallpaper ]]; then
        	rm "$XDG_CONFIG_HOME"/nix-config/assets/bg || echo "no bg file found"
        	cp "$wallpaper" "$XDG_CONFIG_HOME"/nix-config/assets/bg
        	notify-send -i "$HOME"/.config/nix-config/assets/bg "Changing theme (this may take a while)..."
        	home-manager switch --flake "$XDG_CONFIG_HOME"/nix-config/#"$USER"@"$HOSTNAME"
        	notify-send "all done!"
        else
        	echo "no wallpaper selected"
        fi
      '';
    })

    (pkgs.writeShellApplication {
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
    })
  ];
in {
  home.packages = scripts;
}
