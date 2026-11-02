{inputs, ...}: {
  flake.modules.nixos.river = {
    lib,
    pkgs,
    system,
    ...
  }: let
    kwm = inputs.kwm.packages.${system}.default;
    kwim = pkgs.callPackage ./river/_kwim.nix {};
    # Actions are ZON; keep the repeated binding structure here.
    key = modifiers: keysym: event: ''
      .{ .keysym = ${builtins.toJSON keysym}, .modifiers = .{ ${lib.concatMapStringsSep ", " (mod: ".${mod} = true") modifiers} }, .event = ${event} },
    '';
    bind = modifiers: keysym: action:
      key modifiers keysym ".{ .click = .{ .pressed = ${action} } }";
    spawn = modifiers: keysym: command:
      bind modifiers keysym ".{ .spawn_shell = .{ .cmd = ${builtins.toJSON command} } }";
    terminal = "beer -- fish";
    terminalCommand = "beer --";
  in {
    programs.river-classic = {
      enable = true;
      package = pkgs.river;
      extraPackages = [kwm kwim];
    };
    hjem.users.soliprem.files = {
      ".config/river/init".source = pkgs.writeShellScript "river-init" ''
        export XCURSOR_SIZE=24
        export QT_IM_MODULE=fcitx
        export XMODIFIERS=@im=fcitx
        export SDL_IM_MODULE=fcitx
        export GLFW_IM_MODULE=ibus
        export INPUT_METHOD=fcitx
        exec ${kwm}/bin/kwm
      '';
      ".config/kwim/config.zon".text = ''
        .{
            .input_device_rules = .{
                .{ .name = .{ .str = ".*([Tt]ouchpad|[Tt]rackpad).*", .regex = true }, .scroll_factor = 0.5 },
                .{ .repeat_info = .{ .rate = 25, .delay = 600 } },
            },
            .libinput_device_rules = .{
                .{
                    .name = .{ .str = ".*([Tt]ouchpad|[Tt]rackpad).*", .regex = true },
                    .tap = .enabled,
                    .natural_scroll = .enabled,
                    .disable_while_typing = .enabled,
                    .click_method = .clickfinger,
                },
            },
            .xkb_keyboard_rules = .{
                .{ .keymap = .{ .options = .{ .layout = "eu,it", .options = "grp:alt_space_toggle" } } },
            },
        }
      '';
      ".config/kwm/config.zon".text =
        /*
        zon
        */
        ''
          .{
              .bar = .{
                  .show_default = false,
                  .tags = .{ .tags = .{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" } },
              },
              .background = null,
              .disable_wrap_around_for_scroller = true,
              .remember_floating_geometry = true,
              .border = .{ .width = 1 },
              .default_attach_mode = .{ .tile = .stack_top },
              .layout = .{
                  .tile = .{ .inner_gap = 8, .outer_gap = 11 },
                  .monocle = .{ .gap = 11 },
                  .scroller = .{ .inner_gap = 8, .outer_gap = 11 },
              },

              .startup_cmds = .{
                  .{ "sh", "-c", "systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user start nixos-fake-graphical-session.target && rice-style apply" },
                  .{ "beer", "--server" },
                  .{ "battery-monitor" },
                  .{ "emacs", "--daemon" },
                  .{ "nm-applet" },
                  .{ "bitwarden" },
                  .{ "protonvpn-app" },
                  .{ "kanshi" },
                  .{ "stash", "watch" },
                  .{ "sunsetr" },
                  .{ "hex", "start" },
                  .{ "gomuks-web" },
              },

              .bindings = .{
                  .key = .{
                      // Applications and desktop shell.
                      ${spawn ["mod4"] "Return" terminal}
                      ${spawn ["mod4" "shift"] "Return" "emacsclient -c"}
                      ${spawn ["mod4"] "w" "zen-beta"}
                      ${spawn ["mod4"] "e" "nautilus --new-window"}
                      ${spawn ["mod4"] "d" "rice-style action launcher"}
                      ${spawn ["mod4" "shift"] "d" "fuzzel-run"}
                      ${spawn ["mod4" "ctrl"] "r" "rice-style toggle"}
                      ${spawn ["mod4"] "x" "rice-style action panel"}
                      ${spawn ["mod4"] "v" "clipmenu"}
                      ${spawn ["mod4" "mod1"] "l" "rice-lock"}
                      ${spawn ["mod4"] "t" "notify-time"}
                      ${spawn ["mod4"] "b" "notify-battery"}
                      ${spawn ["mod4"] "n" "dm-notes"}
                      ${spawn ["mod4" "shift"] "n" "${terminalCommand} notes"}
                      ${spawn ["mod4"] "o" "dm-hub"}
                      ${spawn ["mod4" "shift"] "semicolon" "dm-expand"}
                      ${spawn ["mod4"] "minus" "wtype -k emdash"}
                      ${spawn ["mod4" "ctrl"] "t" "${terminalCommand} tray-tui"}
                      ${spawn ["mod4" "ctrl"] "w" "${terminalCommand} wiki-tui"}
                      ${spawn ["mod4" "ctrl"] "v" "pwvucontrol"}
                      ${spawn ["mod4" "shift"] "b" "overskride"}
                      ${spawn ["mod4" "shift" "mod1"] "period" "fuzzel-emoji"}
                      ${spawn ["mod4" "mod1"] "n" "dm-sunsetr"}
                      ${spawn ["mod4" "shift"] "m" "rice-style action volume-mute"}
                      ${lib.concatMapStrings (action:
            spawn ["mod4" "ctrl" "mod1"] action.key "rice-style action ${action.name}") [
            {
              key = "v";
              name = "audio";
            }
            {
              key = "n";
              name = "network";
            }
            {
              key = "b";
              name = "bluetooth";
            }
            {
              key = "p";
              name = "power";
            }
            {
              key = "c";
              name = "system";
            }
            {
              key = "m";
              name = "notifications";
            }
            {
              key = "o";
              name = "media";
            }
          ]}

                      // Capture and dictation.
                      ${spawn [] "Print" "rice-style action screenshot-region"}
                      ${spawn ["mod4"] "p" "rice-style action screenshot"}
                      ${spawn ["mod4" "shift"] "s" "rice-style action screenshot-region"}
                      ${spawn ["mod4" "shift"] "p" "rice-style action screenshot-screen"}
                      ${spawn ["mod4" "mod1"] "p" "rice-style action screenshot-window"}
                      ${key [] "F7" ''.{ .click = .{ .pressed = .{ .spawn_shell = .{ .cmd = "hex dictation start" } }, .released = .{ .spawn_shell = .{ .cmd = "hex dictation stop" } } } }''}
                      ${spawn [] "F8" "hex dictation toggle"}
                      ${spawn ["ctrl"] "F8" "hex dictation toggle --raw"}
                      ${spawn ["shift"] "F8" "hex dictation cancel"}
                      ${spawn ["mod1"] "F8" "dm-hex-language"}
                      ${spawn ["ctrl" "mod1"] "v" "hex paste-last"}
                      ${spawn [] "F9" "hex annotate start"}
                      ${spawn ["shift"] "F9" "hex annotate stop"}
                      ${spawn ["ctrl"] "F9" "hex annotate draw"}

                      // Windows, layouts, and outputs.
                      ${bind ["mod4"] "q" ".close"}
                      ${bind ["mod4" "shift"] "q" ".close"}
                      ${bind ["mod4" "shift"] "e" ".{ .quit = .{ .exit_session = true } }"}
                      ${bind ["ctrl" "mod1"] "Delete" ".{ .quit = .{ .exit_session = true } }"}
                      ${bind ["mod4" "ctrl" "shift"] "r" ".reload_config"}
                      ${bind ["mod4" "shift"] "space" ".toggle_floating"}
                      ${bind ["mod4"] "f" ".toggle_maximize"}
                      ${bind ["mod4" "shift"] "f" ".{ .toggle_fullscreen = .{} }"}
                      ${bind ["mod4" "mod1"] "f" ".{ .toggle_fullscreen = .{ .in_window = true } }"}
                      ${bind ["mod4"] "j" ".{ .focus_iter = .{ .direction = .forward } }"}
                      ${bind ["mod4"] "k" ".{ .focus_iter = .{ .direction = .reverse } }"}
                      ${bind ["mod4"] "h" ".{ .focus_iter = .{ .direction = .reverse } }"}
                      ${bind ["mod4"] "l" ".{ .focus_iter = .{ .direction = .forward } }"}
                      ${bind ["mod4" "shift"] "j" ".{ .swap = .{ .direction = .forward } }"}
                      ${bind ["mod4" "shift"] "k" ".{ .swap = .{ .direction = .reverse } }"}
                      ${bind ["mod4"] "space" ".{ .zoom = .{ .swap = true } }"}
                      ${bind ["mod4" "ctrl"] "h" ".{ .modify_mfact = .{ .change = .{ .step = -0.02 } } }"}
                      ${bind ["mod4" "ctrl"] "l" ".{ .modify_mfact = .{ .change = .{ .step = 0.02 } } }"}
                      ${bind ["mod4"] "equal" ".{ .modify_mfact = .{ .change = .{ .step = -0.05 } } }"}
                      ${bind ["mod4" "shift"] "equal" ".{ .modify_mfact = .{ .change = .{ .step = 0.05 } } }"}
                      ${bind ["mod4" "shift"] "h" ".{ .modify_nmaster = .{ .change = .increase } }"}
                      ${bind ["mod4" "shift"] "l" ".{ .modify_nmaster = .{ .change = .decrease } }"}
                      ${bind ["mod4"] "comma" ".{ .focus_output_iter = .{ .direction = .reverse } }"}
                      ${bind ["mod4"] "period" ".{ .focus_output_iter = .{ .direction = .forward } }"}
                      ${bind ["mod4" "shift"] "comma" ".{ .send_to_output = .{ .direction = .reverse } }"}
                      ${bind ["mod4" "shift"] "period" ".{ .send_to_output = .{ .direction = .forward } }"}
                      ${bind ["mod1"] "Tab" ".{ .focus_iter = .{ .direction = .forward } }"}
                      ${bind ["mod4"] "Tab" ".{ .focus_iter = .{ .direction = .forward } }"}
                      ${bind ["mod4" "ctrl"] "Tab" ".switch_to_previous_tag"}
                      ${bind ["mod4" "mod1"] "t" ".{ .switch_layout = .{ .layout = .tile } }"}
                      ${bind ["mod4" "mod1"] "m" ".{ .switch_layout = .{ .layout = .monocle } }"}
                      ${bind ["mod4" "mod1"] "x" ".{ .switch_layout = .{ .layout = .scroller } }"}
                      ${lib.concatMapStrings (number: let
            tag = toString (builtins.elemAt [1 2 4 8 16 32 64 128 256 512] (number - 1));
            sym = toString (lib.mod number 10);
          in ''
            ${bind ["mod4"] sym ".{ .set_output_tag = .{ .tag = .{ .tag = ${tag} } } }"}
            ${bind ["mod4" "shift"] sym ".{ .set_window_tag = .{ .tag = .{ .tag = ${tag} } } }"}
            ${bind ["mod4" "shift" "mod1"] sym ".{ .set_window_tag = .{ .tag = .{ .tag = ${tag} }, .focus_follow = true } }"}
          '') (lib.range 1 10)}

                      // Media controls remain available while locked.
                      ${lib.concatMapStrings (mode:
            lib.concatMapStrings (binding: let
              action = ".{ .spawn_shell = .{ .cmd = ${builtins.toJSON binding.command} } }";
              event =
                if binding.repeat or false
                then ".{ .repeat = ${action} }"
                else ".{ .click = .{ .pressed = ${action} } }";
            in ''
              .{ .mode = "${mode}", .keysym = "${binding.key}", .modifiers = .{}, .event = ${event} },
            '') [
              {
                key = "XF86AudioRaiseVolume";
                command = "rice-style action volume-up";
                repeat = true;
              }
              {
                key = "XF86AudioLowerVolume";
                command = "rice-style action volume-down";
                repeat = true;
              }
              {
                key = "XF86AudioMute";
                command = "rice-style action volume-mute";
              }
              {
                key = "XF86AudioMicMute";
                command = "rice-style action mic-mute";
              }
              {
                key = "XF86MonBrightnessUp";
                command = "rice-style action brightness-up";
                repeat = true;
              }
              {
                key = "XF86MonBrightnessDown";
                command = "rice-style action brightness-down";
                repeat = true;
              }
              {
                key = "XF86AudioPlay";
                command = "playerctl play-pause";
              }
              {
                key = "XF86AudioPrev";
                command = "playerctl previous";
              }
              {
                key = "XF86AudioNext";
                command = "playerctl next";
              }
            ]) ["default" "lock"]}
                      ${spawn [] "XF86PowerOff" "wlogout"}
                  },
              },

              // kwm uses the first matching rule.
              .window_rules = .{
                  .{ .title = .{ .str = "^(Picture-in-Picture)$", .regex = true }, .floating = true, .dimension = .{ .width = 640, .height = 360 } },
                  .{ .title = .{ .str = "^(Julia|flame|script-fu|org[.]gtk_rs[.]HelloWorld2|Open File|Select a File|Choose wallpaper|Open Folder|Save As|Library).*", .regex = true }, .floating = true },
                  .{ .app_id = .{ .str = "^(org[.]kde[.]polkit-kde-authentication-agent-1|proton[.]vpn[.]app[.]gtk|protonvpn-app|eu[.]soliprem[.]thumbpick|zenity|xdg-desktop-portal-gtk)$", .regex = true }, .floating = true },
                  .{ .title = .{ .str = "^(nvim|v|vi|wev|R|glxgears|julia)( |$).*", .regex = true }, .disable_swallow = true },
                  .{ .app_id = .{ .str = "^(foot|kitty|com[.]mitchellh[.]ghostty|beer)$", .regex = true }, .is_terminal = true },
              },
          }
        '';
    };
  };
}
