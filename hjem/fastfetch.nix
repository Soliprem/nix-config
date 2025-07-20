_: {
  hjem.users.soliprem.files = {
    ".config/fastfetch/config.jsonc".text = ''
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": null,
    "display": {
        "separator": "  ",
        "color": "white",
        "constants": ["\u001b[37m", "\u001b[38;5;16m", "\u001b[38;5;17m", "\u001b[38;5;18m"]
    },
    "modules": [
        "break",
        {
            "type": "custom",
            "key": "╭───────────────────────────────────╮"
        },
        {
            "type": "kernel",
            "key": "│ {$2}{$1}  kernel",
            "format": "{$2}{release>22}{$1} │"
        },
        {
            "type": "command",
            "key": "│   uptime",
            "text": "uptime -p | cut -d ' ' -f 2-",
            "format": "{>22} │"
        },
        {
            "type": "shell",
            "key": "│ {$2}{$1}  shell ",
            "format": "{$2}{pretty-name>22}{$1} │"
        },
        {
            "type": "command",
            "key": "│ {$3}{$1}  mem   ",
            "text": "free -m | awk 'NR==2{printf \"%.2f GiB / %.2f GiB\",$3/1024,$2/1024}'",
            "format": "{$3}{>22}{$1} │"
        },
        {
            "type": "packages",
            "key": "│   pkgs  ",
            "format": "{all>22} │"
        },
        {
            "type": "command",
            "key": "│ {$2}{$1}  user  ",
            "text": "echo $USER",
            "format": "{$2}{>22}{$1} │"
        },
        {
            "type": "command",
            "key": "│   hname ",
            "text": "hostnamectl hostname",
            "format": "{>22} │"
        },
        {
            "type": "os",
            "key": "│ {$4}󰻀{$1}  distro",
            "format": "{$4}{pretty-name>22}{$1} │"
        },
        {
            "type": "custom",
            "key": "╰───────────────────────────────────╯"
        },
        "break"
    ]
}

    '';
    ".config/fastfetch/maximal.jsonc".text = ''
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "builtin",
        "height": 15,
        "width": 30,
        "padding": {
            "top": 5,
            "left": 3
        }
    },
    "modules": [
        "break",
        {
            "type": "custom",
            "format": "\u001b[90m┌──────────────────────Hardware──────────────────────┐"
        },
        {
            "type": "host",
            "key": " PC",
            "keyColor": "green"
        },
        {
            "type": "cpu",
            "key": "│ ├",
            "keyColor": "green"
        },
        {
            "type": "gpu",
            "key": "│ ├󰍛",
            "keyColor": "green"
        },
        {
            "type": "memory",
            "key": "│ ├󰍛",
            "keyColor": "green"
        },
        {
            "type": "disk",
            "key": "└ └",
            "keyColor": "green"
        },
        {
            "type": "custom",
            "format": "\u001b[90m└────────────────────────────────────────────────────┘"
        },
        "break",
        {
            "type": "custom",
            "format": "\u001b[90m┌──────────────────────Software──────────────────────┐"
        },
        {
            "type": "os",
            "key": " OS",
            "keyColor": "yellow"
        },
        {
            "type": "kernel",
            "key": "│ ├",
            "keyColor": "yellow"
        },
        {
            "type": "bios",
            "key": "│ ├",
            "keyColor": "yellow"
        },
        {
            "type": "packages",
            "key": "│ ├󰏖",
            "keyColor": "yellow"
        },
        {
            "type": "shell",
            "key": "└ └",
            "keyColor": "yellow"
        },
        "break",
        {
            "type": "de",
            "key": " DE",
            "keyColor": "blue"
        },
        {
            "type": "lm",
            "key": "│ ├",
            "keyColor": "blue"
        },
        {
            "type": "wm",
            "key": "│ ├",
            "keyColor": "blue"
        },
        {
            "type": "wmtheme",
            "key": "│ ├󰉼",
            "keyColor": "blue"
        },
        {
            "type": "terminal",
            "key": "└ └",
            "keyColor": "blue"
        },
        {
            "type": "custom",
            "format": "\u001b[90m└────────────────────────────────────────────────────┘"
        },
        "break",
        {
            "type": "custom",
            "format": "\u001b[90m┌────────────────────Uptime / Age / DT────────────────────┐"
        },
        {
            "type": "command",
            "key": "  OS Age ",
            "keyColor": "magenta",
            "text": "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days"
        },
        {
            "type": "uptime",
            "key": "  Uptime ",
            "keyColor": "magenta"
        },
        {
            "type": "datetime",
            "key": "  DateTime ",
            "keyColor": "magenta"
        },
        {
            "type": "custom",
            "format": "\u001b[90m└─────────────────────────────────────────────────────────┘"
        },

//        {
//            "type": "colors"
//        },

        {
            "type": "colors",
            "paddingLeft": 2,
            "symbol": "circle"
        }
 
    ]
}

    '';
  };
}
