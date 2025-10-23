{pkgs, ...}: {
  hjem.users.soliprem.files = {
    ".config/mango/config.conf".text = ''
      #### Your post SUCKLESS starship to MODERNITY ####
      # waybar & wmenu required.
      # This translation is based on your Hyprland config.
      # Not all Hyprland actions (e.g., special workspace, resizeactive)
      # have direct equivalents in the provided 'mango' spec.

      ## Keybindings (Translated from Hyprland config)

      # Terminal, Launcher, Browser
      bind=SUPER,Return,spawn,ghostty
      bind=SUPER,w,spawn,zen
      bind=SUPER,d,spawn,wmenu-run
      bind=SUPER+SHIFT,d,spawn,fuzzel-run

      # Window Management
      bind=SUPER,Q,killclient
      bind=SUPER+SHIFT,Q,spawn,hyprctl kill
      bind=SUPER+SHIFT,space,togglefloating

      # Focus (Stack-based)
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next

      # Master/Stack Layout
      bind=SUPER,equal,setmfact,-0.05
      bind=SUPER+SHIFT,equal,setmfact,+0.05
      bind=SUPER,space,zoom
      bind=SUPER+SHIFT,h,incnmaster,+1
      bind=SUPER+SHIFT,l,incnmaster,-1

      # Window Exchange (Directional)
      bind=SUPER+SHIFT,j,exchange_client,down
      bind=SUPER+SHIFT,k,exchange_client,up
      bind=SUPER+SHIFT,h,exchange_client,left
      bind=SUPER+SHIFT,l,exchange_client,right

      # Monitor Control
      bind=SUPER,Comma,focusmon,left
      bind=SUPER,Period,focusmon,right
      bind=SUPER+SHIFT,Comma,tagmon,left,0
      bind=SUPER+SHIFT,Period,tagmon,right,0

      # Application/Script Binds
      bind=NONE,XF86PowerOff,spawn,wmenu-run
      bind=SUPER,V,spawn,pkill fuzzel || cliphist list | fuzzel --dmenu | cliphist decode | wl-copy
      bind=SUPER,c,spawn,swaync-client
      bind=SUPER,E,spawn,nautilus --new-window
      bind=SUPER,t,spawn,notify-time
      bind=SUPER+SHIFT,v,spawn,notify-volume
      bind=SUPER,b,spawn,notify-battery
      bind=NONE,Print,spawn,grimblast copy area
      bind=SUPER+SHIFT+ALT,Period,spawn,fuzzel-emoji
      bind=SUPER,n,spawn,dm-notes
      bind=SUPER+SHIFT,n,spawn,ghostty -e notes
      bind=SUPER,m,spawn,astal -i sash -t systemMenuWindow
      bind=SUPER,o,spawn,dm-hub
      bind=SUPER+shift,semicolon,spawn,dm-expand
      bind=SUPER,minus,spawn,wtype -k emdash
      bind=SUPER+SHIFT,B,spawn,astal -i sash bars
      bind=SUPER,f,setlayout,monocle
      bind=SUPER+SHIFT,f,setlayout,tile
      bind=SUPER+Alt,l,spawn,notify-send "implement a lock plz"

      # Screenshots
      bind=SUPER,P,spawn,hyprshot -m output -c -r - | swappy -f -
      bind=SUPER+SHIFT,P,spawn,hyprshot -m window -r - | swappy -f -
      bind=SUPER+SHIFT,S,spawn,hyprshot -m region -r - |swappy -f -

      # Media Keys (Volume)
      bind=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bind=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-volume

      # Media Keys (Mic)
      bind=NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_SOURCE@ toggle && notify-send \"Toggling Microphone\"
      bind=SUPER+SHIFT,M,spawn,swayosd-client --output-volume mute-toggle

      # Media Keys (Playback)
      bind=NONE,XF86AudioMedia,spawn,playerctl play-pause
      bind=NONE,XF86AudioPlay,spawn,playerctl play-pause
      bind=NONE,XF86AudioPrev,spawn,playerctl previous
      bind=NONE,XF86AudioNext,spawn,playerctl next

      # Media Keys (Brightness)
      bind=NONE,XF86MonBrightnessUp,spawn,brightnessctl set '12.75+'
      bind=NONE,XF86MonBrightnessDown,spawn,brightnessctl set '12.75-'

      # Other Keys
      bind=NONE,Caps_Lock,spawn,sleep 0.1 && swayosd-client --caps-lock

      # Workspace/Tag Binds (1-9, and 0 for 10)
      bind=SUPER,1,comboview,1
      bind=SUPER,2,comboview,2
      bind=SUPER,3,comboview,3
      bind=SUPER,4,comboview,4
      bind=SUPER,5,comboview,5
      bind=SUPER,6,comboview,6
      bind=SUPER,7,comboview,7
      bind=SUPER,8,comboview,8
      bind=SUPER,9,comboview,9
      bind=SUPER,0,comboview,10

      # Default Layout Binds (from mango spec, may be overridden by your binds above)
      bind=SUPER,t,setlayout,tile
      bind=SUPER,m,setlayout,monocle
      bind=SUPER,v,setlayout,vertical_grid
      bind=SUPER+SHIFT,v,setlayout,vertical_scroller
      bind=SUPER+CONTROL,L,switch_proportion_preset

      ## Mouse Bindings
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=SUPER,btn_right,moveresize,curresize
      mousebind=NONE,btn_left,toggleoverview,-1
      mousebind=NONE,btn_right,killclient,0

      ## Settings
      # Mapped from Hyprland config
      borderpx=1
      new_is_master=0
      scroller_prefer_center = 1 # Mapped from hyprscrolling.focus_fit_method
      sloppyfocus=0 # Mapped from input.follow_mouse = 2

      # "Suckless" defaults from mango spec
      # animations=0
      # gappih=0
      # gappiv=0
      # gappoh=0
      # gappov=0
      # no_border_when_single=1
      # focuscolor=0x005577ff

      # Other defaults from mango spec
      scroller_default_proportion = 0.5
      enable_hotarea=0
      warpcursor=1
      axis_bind_apply_timeout=100
      drag_tile_to_tile=1
      enable_floating_snap=0
      snap_distance=30

      ## Layout Rules
      # Mapped from general.layout = "scrolling"
      tagrule=id:1,layout_name:scroller
      tagrule=id:2,layout_name:scroller
      tagrule=id:3,layout_name:scroller
      tagrule=id:4,layout_name:scroller
      tagrule=id:5,layout_name:scroller
      tagrule=id:6,layout_name:scroller
      tagrule=id:7,layout_name:scroller
      tagrule=id:8,layout_name:scroller
      tagrule=id:9,layout_name:scroller
    '';
    ".config/mango/autostart.sh".source = pkgs.writeShellApplication {
      name = "autostart.sh";
      runtimeInputs = [];
      text = ''
      walker --gapplication-service &
      wl-paste --type text --watch cliphist store &
      wl-paste --type image --watch cliphist store &
      xwayland-satellite &
      swww-daemon &
      waybar &
      swaync &
      nm-applet &
      swaync &
      notify-send Commander...
      notify-send beer me!
      '';
    };
  };
}
