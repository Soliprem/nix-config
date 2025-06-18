_: {
  hjem.users.soliprem.files = {
    ".config/way-edges/config.jsonc".text = ''
      {
        // "$schema": "https://raw.githubusercontent.com/way-edges/way-edges/master/config/config.schema.json",
        "$schema": "./schema.json",
        "widgets": [
          {
            "edge": "right",
            "position": "top",
            "monitor": "*",
            "layer": "overlay",
            "margins": {
              "top": "10%"
            },
            "thickness": 40,
            "length": "25%",
            "fg-color": "#85C9E8cc",
            "bg-color": "#0000",
            "border-color": "#85C9E8ff",
            "fg-text-color": "#fffa",
            "bg-text-color": "#fffa",
            "radius": 10,
            "obtuse-angle": 90,
            "type": "slider",
            "preset": {
              "type": "backlight"
            }
          },
          {
            "pin-with-key": false,
            "edge": "top",
            "position": "left",
            "monitor": "*",
            "layer": "overlay",
            "margins": {
              "left": "25%"
            },
            "thickness": 20,
            "length": "25%",
            "type": "btn",
            "color": "#333",
            "event-map": {
              "272": "niri msg action focus-column-left",
              "273": "niri msg action focus-workspace-up"
            }
          },
          {
            "pin-with-key": false,
            "edge": "top",
            "position": "right",
            "monitor": "*",
            "layer": "overlay",
            "margins": {
              "right": "25%"
            },
            "thickness": 20,
            "length": "25%",
            "type": "btn",
            "color": "#333",
            "event-map": {
              "272": "niri msg action focus-column-right",
              "273": "niri msg action focus-workspace-down"
            }
          },
          {
            "pin-with-key": false,
            "edge": "bottom",
            "monitor": "*",
            "layer": "overlay",
            "thickness": 20,
            "length": "40%",
            "type": "btn",
            "event-map": {
              "273": "niri msg action maximize-column",
              "272": "sh -c pkill nwg-drawer || nwg-drawer",
              "274": "niri msg action close-window",
              "276": "niri msg action toggle-column-tabbed-display",
              "275": "niri msg action toggle-overview"
            }
          },
          // {
          //   "edge": "left",
          //   "position": "bottom",
          //   "layer": "overlay",
          //   "monitor": "*",
          //   "type": "workspace",
          //   "thickness": 30,
          //   "length": "50%",
          //   "hover-color": "#ffffff22",
          //   "active-increase": 0.2,
          //   /// "active-color": "#fff",
          //   "focus-color": "#4E884F",
          //   "default-color": "#000",
          //   "focused-only": true,
          //   "preset": { "type": "niri", "filter-empty": false }
          // },
          {
            "edge": "right",
            "position": "bottom",
            "layer": "overlay",
            "monitor": "*",
            "type": "workspace",
            "thickness": 30,
            "length": "50%",
            "hover-color": "#ffffff22",
            "active-increase": 0.2,
            /// "active-color": "#fff",
            "focus-color": "#4E884F",
            "default-color": "#000",
            "focused-only": true,
            "preset": { "type": "niri", "filter-empty": false }
          },
          {
            "namespace": "stats",
            "edge": "left",
            "position": "top",
            "margins": {
              "top": 40
            },
            "monitor": "*",
            "layer": "overlay",
            "type": "wrap-box",
            "outlook": {
              "type": "window",
              "color": "#5d3f3c"
            },
            "items": [
              {
                // "radius": 18,
                // "ring-width": 8,
                "font-size": 20,
                "font-family": "JetBrainsMono Nerd Font",
                "fg-color": "#82B2E3",
                "bg-color": "#00000044",
                "type": "ring",
                "prefix": " ",
                "suffix": " {preset}",
                "suffix-hide": true,
                "preset": {
                  "update-interval": 500,
                  "type": "disk"
                }
              },
              {
                // "radius": 18,
                // "ring-width": 8,
                "font-size": 20,
                "font-family": "JetBrainsMono Nerd Font",
                "fg-color": "#FFB77B",
                "bg-color": "#00000044",
                "type": "ring",
                "prefix": " ",
                "suffix": " {preset}",
                "suffix-hide": true,
                "preset": {
                  "update-interval": 500,
                  "type": "battery"
                }
              },
              {
                // "radius": 18,
                // "ring-width": 8,
                "font-size": 20,
                "font-family": "JetBrainsMono Nerd Font",
                "fg-color": "#FB8893",
                "bg-color": "#00000044",
                "type": "ring",
                "prefix": " ",
                "suffix": " {preset}",
                "suffix-hide": true,
                "preset": {
                  "update-interval": 500,
                  "type": "cpu"
                }
              },
              {
                // "radius": 18,
                // "ring-width": 8,
                "font-size": 20,
                "font-family": "JetBrainsMono Nerd Font",
                "fg-color": "#BEAFD9",
                "bg-color": "#00000044",
                "type": "ring",
                "prefix": "󰾶 ",
                "suffix": " {preset}",
                "suffix-hide": true,
                "preset": {
                  "update-interval": 500,
                  "type": "swap"
                }
              },
              {
                // "radius": 18,
                // "ring-width": 8,
                "font-size": 20,
                "font-family": "JetBrainsMono Nerd Font",
                "bg-color": "#00000044",
                "type": "ring",
                "prefix": " ",
                "suffix": " {preset}",
                "suffix-hide": true,
                "preset": {
                  "update-interval": 500,
                  "type": "ram"
                }
              }
            ]
          },
          {
            "namespace": "time",
            "edge": "top",
            "position": "right",
            "monitor": "*",
            "layer": "overlay",
            "type": "wrap-box",
            "outlook": {
              "type": "window",
              "color": "#222",
              "margins": {
                "top": 10,
                "left": 30,
                "right": 30,
                "bottom": 10
              }
            },
            "items": [
              {
                "type": "text",
                "fg-color": "#FFFFFF",
                "font-size": 30,
                "font-family": "serif",
                "preset": {
                  "type": "time",
                  "update-interval": 500,
                  "format": "%v %T %A"
                }
              }
            ]
          },
          {
            "edge": "top",
            "monitor": "*",
            "layer": "overlay",
            "position": "left",
            // "preview-size": 0,
            "type": "slider",
            "thickness": 40,
            "border-width": 3,
            "length": "12.5%",
            "radius": 10,
            "obtuse-angle": 90,
            "fg-color": "#18A558cc",
            "bg-color": "#0000",
            "border-color": "#18A558",
            "fg-text-color": "#fffa",
            "bg-text-color": "#fffa",
            "redraw-only-on-internal-update": true,
            "preset": {
              "type": "speaker"
            }
          },
          {
            "edge": "top",
            "monitor": "*",
            "position": "left",
            "layer": "overlay",
            "margins": {
              "left": "12.5%"
            },
            // "preview-size": 9,
            "type": "slider",
            "thickness": 40,
            "border-width": 3,
            "length": "12.5%",
            "radius": 10,
            "obtuse-angle": 90,
            "fg-color": "#BD93F9cc",
            "bg-color": "#0000",
            "border-color": "#BD93F9",
            "fg-text-color": "#fffa",
            "bg-text-color": "#fffa",
            "redraw-only-on-internal-update": true,
            "preset": {
              "type": "microphone"
            }
          },
          {
            "namespace": "tray",
            "edge": "bottom",
            "position": "left",
            "monitor": "*",
            "layer": "overlay",
            "type": "wrap-box",
            "align": "bottom-left",
            "outlook": {
              "type": "window",
              "color": "#0C986C"
            },
            "items": [
              {
                "font-family": "sans-serif",
                "type": "tray",
                "icon-size": 40,
                "header-menu-stack": "menu-top",
                "header-menu-align": "left",
                "menu-draw-config": {
                  "font-pixel-height": 18,
                  "text-color": "#eee",
                  "border-color": "#111"
                },
                "header-draw-config": {
                  "text-color": "#eee"
                },
                "grid-align": "bottom-left"
              }
            ]
          },
          // {
          //   "namespace": "tray",
          //   "edge": "bottom",
          //   "position": "right",
          //   "monitor": "*",
          //   "layer": "overlay",
          //   "type": "wrap-box",
          //   "align": "bottom-left",
          //   "outlook": {
          //     "type": "window",
          //     "color": "#0C986C"
          //   },
          //   "items": [
          //     {
          //       "font-family": "sans-serif",
          //       "type": "tray",
          //       "icon-size": 40,
          //       "header-menu-stack": "menu-top",
          //       "header-menu-align": "left",
          //       "menu-draw-config": {
          //         "font-pixel-height": 18,
          //         "text-color": "#eee",
          //         "border-color": "#111"
          //       },
          //       "header-draw-config": {
          //         "text-color": "#eee"
          //       },
          //       "grid-align": "bottom-left"
          //     }
          //   ]
          // }
        ]
      }
    '';
  };
}
