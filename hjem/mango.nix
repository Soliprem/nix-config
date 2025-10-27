{pkgs, ...}: {
  hjem.users.soliprem.files = {
    ".config/mango/config.conf".text = ''
      # More option see https://github.com/DreamMaoMao/mango/wiki/

      # Window effect
      blur=1
      blur_layer=1
      blur_optimized=0
      blur_params_num_passes = 2
      blur_params_radius = 5
      blur_params_noise = 0.02
      blur_params_brightness = 0.9
      blur_params_contrast = 0.9
      blur_params_saturation = 1.2

      shadows = 0
      layer_shadows = 0
      shadow_only_floating = 1
      shadows_size = 10
      shadows_blur = 15
      shadows_position_x = 0
      shadows_position_y = 0
      shadowscolor= 0x000000ff

      border_radius=6
      no_radius_when_single=0
      focused_opacity=1.0
      unfocused_opacity=1.0

      # Animation Configuration(support type:zoom,slide)
      # tag_animation_direction: 0-horizontal,1-vertical
      animations=1
      layer_animations=1
      animation_type_open=fade
      animation_type_close=fade
      animation_fade_in=1
      animation_fade_out=1
      tag_animation_direction=0
      zoom_initial_ratio=0.3
      zoom_end_ratio=0.8
      fadein_begin_opacity=0.5
      fadeout_begin_opacity=0.8
      animation_duration_move=200
      animation_duration_open=100
      animation_duration_tag=90
      animation_duration_close=100
      animation_curve_open=0.46,1.0,0.29,1
      animation_curve_move=0.46,1.0,0.29,1
      animation_curve_tag=0.46,1.0,0.29,1
      animation_curve_close=0.08,0.92,0,1

      # Scroller Layout Setting
      scroller_structs=20
      scroller_default_proportion = 0.5
      scroller_focus_center = 0
      scroller_prefer_center = 0
      edge_scroller_pointer_focus=1
      scroller_default_proportion_single=1.0
      scroller_proportion_preset=0.3,0.5,0.8,1.0

      # Master-Stack Layout Setting
      new_is_master=0
      default_mfact=0.55
      default_nmaster=1
      smartgaps=0

      # Overview Setting
      hotarea_size=10
      enable_hotarea=0
      ov_tab_mode=0
      overviewgappi=5
      overviewgappo=30

      # Misc
      no_border_when_single=0
      axis_bind_apply_timeout=100
      focus_on_activate=1
      inhibit_regardless_of_visibility=0
      sloppyfocus=0
      warpcursor=1
      focus_cross_monitor=0
      focus_cross_tag=0
      enable_floating_snap=0
      snap_distance=30
      cursor_size=24
      drag_tile_to_tile=1

      # keyboard
      repeat_rate=25
      repeat_delay=600
      numlockon=0
      xkb_rules_layout=eu

      # Trackpad
      # need relogin to make it apply
      disable_trackpad=0
      tap_to_click=1
      tap_and_drag=1
      drag_lock=1
      trackpad_natural_scrolling=0
      disable_while_typing=1
      left_handed=0
      middle_button_emulation=0
      swipe_min_threshold=1

      # mouse
      # need relogin to make it apply
      mouse_natural_scrolling=0

      # Appearance
      gappih=5
      gappiv=5
      gappoh=10
      gappov=10
      scratchpad_width_ratio=0.8
      scratchpad_height_ratio=0.9
      borderpx=1
      rootcolor=0x201b14ff
      bordercolor=0x444444ff
      focuscolor=0xc9b890ff
      # focuscolor=0x005577ff
      maxmizescreencolor=0x89aa61ff
      urgentcolor=0xad401fff
      scratchpadcolor=0x516c93ff
      globalcolor=0xb153a7ff
      overlaycolor=0x14a57cff

      # Layout Rules
      tagrule=id:1,layout_name:scroller
      tagrule=id:2,layout_name:scroller
      tagrule=id:3,layout_name:scroller
      tagrule=id:4,layout_name:scroller
      tagrule=id:5,layout_name:scroller
      tagrule=id:6,layout_name:scroller
      tagrule=id:7,layout_name:scroller
      tagrule=id:8,layout_name:scroller
      tagrule=id:9,layout_name:scroller

      # Monitor Config
      monitorrule=HDMI-A-1, 0.55,1,scroller,0,1,2560, 0, 1920,1080,144.013000
      monitorrule=DP-3, 0.55,1,scroller,0,1,0,0,2560, 1440, 180.001999

      # --- Keymodes and Bindings ---

      # Common mode - bindings available in all modes
      keymode = common
      bind=SUPER+CTRL,R,reload_config
      bind=SUPER+CTRL,t,spawn,ghostty -e tray-tui
      bind=SUPER,g,toggleoverview
      bind=SUPER,s,toggleglobal
      bind=SUPER+SHIFT,o,toggleoverlay

      # Terminal, Launcher, Browser
      bind=SUPER,Return,spawn,ghostty
      bind=SUPER,w,spawn,zen
      bind=SUPER,d,spawn,wmenu-run
      bind=SUPER+SHIFT,d,spawn,fuzzel

      # Window Management
      bind=SUPER,Q,killclient
      bind=SUPER+SHIFT,space,togglefloating

      # Monitor Control
      bind=SUPER,comma,focusmon,left
      bind=SUPER,period,focusmon,right
      bind=SUPER+SHIFT,comma,tagmon,left,0
      bind=SUPER+SHIFT,period,tagmon,right,0

      # Application/Script Binds
      bind=NONE,XF86PowerOff,spawn,wmenu-run
      bind=SUPER,V,spawn,pkill fuzzel || cliphist list | fuzzel --dmenu | cliphist decode | wl-copy
      bind=SUPER,c,spawn,swaync-client -t
      bind=SUPER,E,spawn,nautilus --new-window
      bind=SUPER,t,spawn,notify-time
      bind=SUPER+SHIFT,v,spawn,notify-volume
      bind=SUPER,b,spawn,notify-battery
      bind=NONE,Print,spawn,grimblast copy area
      bind=SUPER+SHIFT+ALT,period,spawn,fuzzel-emoji
      bind=SUPER,n,spawn,dm-notes
      bind=SUPER+SHIFT,n,spawn,ghostty -e notes
      bind=SUPER,m,spawn,astal -i sash -t systemMenuWindow
      bind=SUPER,o,spawn,dm-hub
      bind=SUPER+SHIFT,semicolon,spawn,dm-expand
      bind=SUPER,minus,spawn,wtype -k emdash
      bind=SUPER+SHIFT,B,spawn,astal -i sash bars
      bind=SUPER,f,togglemaxmizescreen
      bind=SUPER+SHIFT,f,togglefullscreen
      bind=SUPER+ALT,f,togglefakefullscreen
      bind=SUPER+ALT,l,spawn,notify-send "implement a lock plz"

      # Screenshots
      bind=SUPER,P,spawn,grimpick
      bind=SUPER+SHIFT,S,spawn,grimpick region

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

      # Workspace/Tag Binds (1-9)
      bind=SUPER,1,comboview,1
      bind=SUPER,2,comboview,2
      bind=SUPER,3,comboview,3
      bind=SUPER,4,comboview,4
      bind=SUPER,5,comboview,5
      bind=SUPER,6,comboview,6
      bind=SUPER,7,comboview,7
      bind=SUPER,8,comboview,8
      bind=SUPER,9,comboview,9
      bind=SUPER+CTRL,1,toggleview,1
      bind=SUPER+CTRL,2,toggleview,2
      bind=SUPER+CTRL,3,toggleview,3
      bind=SUPER+CTRL,4,toggleview,4
      bind=SUPER+CTRL,5,toggleview,5
      bind=SUPER+CTRL,6,toggleview,6
      bind=SUPER+CTRL,7,toggleview,7
      bind=SUPER+CTRL,8,toggleview,8
      bind=SUPER+CTRL,9,toggleview,9
      bind=SUPER+SHIFT,1,tag,1
      bind=SUPER+SHIFT,2,tag,2
      bind=SUPER+SHIFT,3,tag,3
      bind=SUPER+SHIFT,4,tag,4
      bind=SUPER+SHIFT,5,tag,5
      bind=SUPER+SHIFT,6,tag,6
      bind=SUPER+SHIFT,7,tag,7
      bind=SUPER+SHIFT,8,tag,8
      bind=SUPER+SHIFT,9,tag,9

      # Layout Switching (Automatically switches keymode too)
      bind=SUPER+SHIFT,T,setlayout,tile
      bind=SUPER+SHIFT,T,setkeymode,tile
      bind=SUPER+SHIFT,M,setlayout,monocle
      bind=SUPER+SHIFT,M,setkeymode,monocle
      bind=SUPER+SHIFT,G,setlayout,grid
      bind=SUPER+SHIFT,G,setkeymode,grid
      bind=SUPER+SHIFT,X,setlayout,scroller
      bind=SUPER+SHIFT,X,setkeymode,default
      bind=SUPER+CTRL+SHIFT,D,setlayout,deck
      bind=SUPER+CTRL+SHIFT,D,setkeymode,deck
      bind=SUPER+SHIFT,C,setlayout,center_tile
      bind=SUPER+SHIFT,C,setkeymode,center_tile
      bind=SUPER+SHIFT,R,setlayout,right_tile
      bind=SUPER+SHIFT,R,setkeymode,right_tile
      bind=SUPER+SHIFT,V,setlayout,vertical_tile
      bind=SUPER+SHIFT,V,setkeymode,vertical_tile
      bind=SUPER+CTRL,G,setlayout,vertical_grid
      bind=SUPER+CTRL,G,setkeymode,vertical_grid
      bind=SUPER+CTRL,X,setlayout,vertical_scroller
      bind=SUPER+CTRL,X,setkeymode,vertical_scroller
      bind=SUPER+CTRL,D,setlayout,vertical_deck
      bind=SUPER+CTRL,D,setkeymode,vertical_deck

      bind=SUPER+CTRL,L,switch_proportion_preset

      # Cycle through keymodes
      bind=SUPER+CTRL+SHIFT,S,setkeymode,cycle

      ## Mouse Bindings
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=SUPER,btn_right,moveresize,curresize
      mousebind=NONE,btn_left,toggleoverview,-1
      mousebind=NONE,btn_right,killclient,0

      # --- Layout Specific Keymodes ---

      # Scroller ('default' mode because it's the default layout in tagrules)
      keymode=default
      bind=SUPER,r,switch_proportion_preset
      bind=SUPER,h,focusstack,prev
      bind=SUPER,l,focusstack,next
      bind=SUPER+SHIFT,h,exchange_stack_client,prev
      bind=SUPER+SHIFT,l,exchange_stack_client,next
      bind=SUPER,j,viewtoright
      bind=SUPER,k,viewtoleft
      bind=SUPER+SHIFT,j,tagtoright
      bind=SUPER+SHIFT,k,tagtoleft

      # Tile (Master/Stack)
      keymode=tile
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next
      bind=SUPER+SHIFT,k,exchange_stack_client,prev
      bind=SUPER+SHIFT,j,exchange_stack_client,next
      bind=SUPER,equal,setmfact,-0.05
      bind=SUPER+SHIFT,equal,setmfact,+0.05
      bind=SUPER,space,zoom
      bind=SUPER+SHIFT,h,incnmaster,+1
      bind=SUPER+SHIFT,l,incnmaster,-1

      # Monocle
      keymode=monocle
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next
      bind=SUPER+SHIFT,k,exchange_stack_client,prev
      bind=SUPER+SHIFT,j,exchange_stack_client,next

      # Grid
      keymode=grid
      bind=SUPER,k,focusdir,up
      bind=SUPER,j,focusdir,down
      bind=SUPER,h,focusdir,left
      bind=SUPER,l,focusdir,right
      bind=SUPER+SHIFT,k,exchange_client,up
      bind=SUPER+SHIFT,j,exchange_client,down
      bind=SUPER+SHIFT,h,exchange_client,left
      bind=SUPER+SHIFT,l,exchange_client,right

      # Deck
      keymode=deck
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next
      bind=SUPER+SHIFT,k,exchange_stack_client,prev
      bind=SUPER+SHIFT,j,exchange_stack_client,next
      bind=SUPER,equal,setmfact,-0.05
      bind=SUPER+SHIFT,equal,setmfact,+0.05
      bind=SUPER,space,zoom
      bind=SUPER+SHIFT,h,incnmaster,+1
      bind=SUPER+SHIFT,l,incnmaster,-1

      # Center Tile
      keymode=center_tile
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next
      bind=SUPER+SHIFT,k,exchange_stack_client,prev
      bind=SUPER+SHIFT,j,exchange_stack_client,next
      bind=SUPER,equal,setmfact,-0.05
      bind=SUPER+SHIFT,equal,setmfact,+0.05
      bind=SUPER,space,zoom
      bind=SUPER+SHIFT,h,incnmaster,+1
      bind=SUPER+SHIFT,l,incnmaster,-1

      # Right Tile (Similar to Tile, but master is on the right)
      keymode=right_tile
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next
      bind=SUPER+SHIFT,k,exchange_stack_client,prev
      bind=SUPER+SHIFT,j,exchange_stack_client,next
      bind=SUPER,equal,setmfact,-0.05
      bind=SUPER+SHIFT,equal,setmfact,+0.05
      bind=SUPER,space,zoom
      bind=SUPER+SHIFT,h,incnmaster,+1
      bind=SUPER+SHIFT,l,incnmaster,-1

      # Vertical Tile
      keymode=vertical_tile
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next
      bind=SUPER+SHIFT,k,exchange_stack_client,prev
      bind=SUPER+SHIFT,j,exchange_stack_client,next
      bind=SUPER,equal,setmfact,-0.05
      bind=SUPER+SHIFT,equal,setmfact,+0.05
      bind=SUPER,space,zoom
      bind=SUPER+SHIFT,h,incnmaster,+1
      bind=SUPER+SHIFT,l,incnmaster,-1

      # Vertical Grid
      keymode=vertical_grid
      bind=SUPER,k,focusdir,up
      bind=SUPER,j,focusdir,down
      bind=SUPER,h,focusdir,left
      bind=SUPER,l,focusdir,right
      bind=SUPER+SHIFT,k,exchange_client,up
      bind=SUPER+SHIFT,j,exchange_client,down
      bind=SUPER+SHIFT,h,exchange_client,left
      bind=SUPER+SHIFT,l,exchange_client,right

      # Vertical Scroller
      keymode=vertical_scroller
      bind=SUPER,r,switch_proportion_preset
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next
      bind=SUPER+SHIFT,k,exchange_stack_client,prev
      bind=SUPER+SHIFT,j,exchange_stack_client,next

      # Vertical Deck
      keymode=vertical_deck
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next
      bind=SUPER+SHIFT,k,exchange_stack_client,prev
      bind=SUPER+SHIFT,j,exchange_stack_client,next
      bind=SUPER,equal,setmfact,-0.05
      bind=SUPER+SHIFT,equal,setmfact,+0.05
      bind=SUPER,space,zoom
      bind=SUPER+SHIFT,h,incnmaster,+1
      bind=SUPER+SHIFT,l,incnmaster,-1
    '';
    ".config/mango/autostart.sh".source = pkgs.writers.writeBash "autostart.sh" ''
      walker --gapplication-service &
      wl-paste --type text --watch cliphist store &
      wl-paste --type image --watch cliphist store &
      xwayland-satellite &
      swww-daemon &
      swaync &
      nm-applet &
      swaync &
      notify-send Commander...
      notify-send beer me!
      '';
  };
}
