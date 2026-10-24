{
  flake.modules.nixos.mango = {
    programs.mango.enable = true;
    hardware.graphics.enable = true;
    hjem.users.soliprem = {pkgs, ...}: let
      # Independent launch commands: do not append applications to the shell launch.
      # Beer: "beer -- fish" / "beer --"; Ghostty: "ghostty" / "ghostty -e".
      terminal = "beer -- fish";
      terminalCommand = "beer --";
    in {
      files = {
        ".config/mango/config.conf".text = ''
          # More options: https://mangowm.github.io/docs/

          # Window effect
          blur=1
          blur_layer=1
          blur_optimized=1
          blur_params_num_passes = 2
          blur_params_radius = 8

          shadows = 0
          layer_shadows = 0
          shadow_only_floating = 1
          shadows_size = 10
          shadows_blur = 15
          shadows_position_x = 0
          shadows_position_y = 0
          shadows_color= 0x000000ff

          border_radius=15
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
          fade_in_begin_opacity=0.5
          fade_out_begin_opacity=0.8
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
          default_master_factor=0.55
          default_master_count=1
          smart_gaps=0

          # Overview Setting
          hotarea_size=10
          enable_hotarea=0
          overview_gap_inner=5
          overview_gap_outer=30

          # Misc
          no_border_when_single=0
          axis_bind_apply_timeout=100
          focus_on_activate=1
          sloppy_focus=0
          warp_cursor=1
          focus_cross_monitor=0
          focus_cross_tag=0
          enable_floating_snap=0
          snap_distance=30
          cursor_size=24
          drag_tile_to_tile=1

          # keyboard
          repeat_rate=25
          repeat_delay=600
          numlock_on=0
          xkb_rules_layout=eu,it
          xkb_rules_options=grp:alt_space_toggle

          # Environment
          env=GTK_IM_MODULE,fcitx
          env=QT_IM_MODULE,fcitx
          env=QT_IM_MODULES,wayland;fcitx
          env=SDL_IM_MODULE,fcitx
          env=XMODIFIERS,@im=fcitx
          env=GLFW_IM_MODULE,ibus
          env=INPUT_METHOD,fcitx
          env=WLR_RENDERER,vulkan

          # Trackpad
          # need relogin to make it apply
          disable_trackpad=0
          tap_to_click=1
          tap_and_drag=1
          drag_lock=1
          trackpad_natural_scrolling=1
          trackpad_middle_button_emulation=1
          swipe_min_threshold=1

          # mouse
          # need relogin to make it apply
          mouse_natural_scrolling=0

          # Appearance
          gap_inner_horizontal=10
          gap_inner_vertical=10
          gap_outer_horizontal=10
          gap_outer_vertical=10
          scratchpad_width_ratio=0.8
          scratchpad_height_ratio=0.9
          scratchpad_cross_monitor=1
          border_px=1
          root_color=0x201b14ff
          border_color=0x444444ff
          focus_color=0xc9b890ff
          # focus_color=0x005577ff
          maximized_screen_color=0x89aa61ff
          urgent_color=0xad401fff
          scratchpad_color=0x516c93ff
          global_color=0xb153a7ff
          overlay_color=0x14a57cff

          # Layout Rules
          tag_rule=id:1,layout_name:tile
          tag_rule=id:2,layout_name:tile
          tag_rule=id:3,layout_name:tile
          tag_rule=id:4,layout_name:tile
          tag_rule=id:5,layout_name:tile
          tag_rule=id:6,layout_name:tile
          tag_rule=id:7,layout_name:tile
          tag_rule=id:8,layout_name:tile
          tag_rule=id:9,layout_name:tile

          # Window Rules
          window_rule=is_floating:1,title:^(Julia|flame|script-fu|org.gtk_rs.HelloWorld2)$
          window_rule=is_floating:1,title:^(Picture-in-Picture)$
          window_rule=is_floating:1,title:^(Open File|Select a File|Choose wallpaper|Open Folder|Save As|Library)(.*)$
          window_rule=is_floating:1,app_id:^(org.kde.polkit-kde-authentication-agent-1)$
          window_rule=is_named_scratchpad:1,app_id:^(Bitwarden|bitwarden|com[.]bitwarden[.]desktop)$
          window_rule=is_named_scratchpad:1,app_id:^(proton[.]vpn[.]app[.]gtk|protonvpn-app)$
          window_rule=is_floating:1,app_id:^(eu.soliprem.thumbpick)$
          window_rule=offset_x:100,offset_y:-100,width:640,height:360,title:^(Picture-in-Picture)$
          window_rule=offset_x:0,offset_y:0,width:900,height:700,title:^(flame|script-fu)$
          window_rule=is_term:1,app_id:^(foot|kitty|com.mitchellh.ghostty)$
          window_rule=no_swallow:1,title:^(nvim|v|vi|wev|R|glxgears|julia)(.*)$
          window_rule=force_tearing:1,app_id:^(mpv|steam_app)(.*)$
          window_rule=force_tearing:1,title:^(.*)(YouTube|Invidious)(.*)$

          # Layer Rules
          layer_rule=no_blur:0,layer_name:^logout_dialog$
          layer_rule=no_blur:0,layer_name:^launcher$
          layer_rule=no_blur:0,layer_name:^quickshell-sidebar$
          layer_rule=no_blur:0,layer_name:^quantum-notification-popups$
          layer_rule=layer_name:selection,no_blur:1,no_animation:1

          # Monitor Config
          monitor_rule=name:^HDMI-A-1$,width:1920,height:1080,refresh:120,x:2560,y:0
          monitor_rule=model:Q27G3XMN,serial:1APQ7JA005710,width:2560,height:1440,refresh:180.002,x:0,y:0,hdr:1
          monitor_rule=name:^eDP-1$,width:1920,height:1200,refresh:60,x:0,y:0,scale:1
          monitor_rule=make:Seiko Epson Corporation,model:EPSON PJ,serial:0x01010101,scale:1.5

          # --- Keymodes and Bindings ---

          # Common mode - bindings available in all modes
          key_mode = common
          bind=SUPER+CTRL,R,reload_config
          bind=SUPER+CTRL,t,spawn,${terminalCommand} tray-tui
          bind=SUPER+CTRL,w,spawn,${terminalCommand} wiki-tui
          bind=SUPER,g,toggleoverview
          bind=SUPER,s,toggle_scratchpad
          # Named scratchpads launch on demand and stay separate from the normal pool.
          bind=SUPER+ALT,b,toggle_named_scratchpad,^(Bitwarden|bitwarden|com[.]bitwarden[.]desktop)$,none,bitwarden
          bind=SUPER+ALT,v,toggle_named_scratchpad,^(proton[.]vpn[.]app[.]gtk|protonvpn-app)$,none,protonvpn-app
          bind=SUPER+ALT,s,minimized
          bind=SUPER+CTRL,s,toggleglobal
          bind=SUPER+SHIFT,o,toggleoverlay
          bind=SUPER,i,minimized
          bind=SUPER+SHIFT,i,restore_minimized
          bind=ALT,Tab,focuslast

          # Terminal, Launcher, Browser
          bind=SUPER,Return,spawn,${terminal}
          bind=SUPER+SHIFT,Return,spawn,emacsclient -c
          bind=SUPER,w,spawn,zen-beta
          bind=SUPER,d,spawn,fuzzel
          bind=SUPER+SHIFT,d,spawn,fuzzel-run

          # Window Management
          bind=SUPER,Q,killclient
          bind=SUPER+SHIFT,Q,killclient
          bind=SUPER+SHIFT,E,quit
          bind=CTRL+ALT,Delete,quit
          bind=SUPER+SHIFT,space,togglefloating

          # Monitor Control
          bind=SUPER,comma,focusmon,left
          bind=SUPER,period,focusmon,right
          bind=SUPER+SHIFT,comma,tagmon,left,0
          bind=SUPER+SHIFT,period,tagmon,right,0
          bind=SUPER+CTRL,comma,tagmon,left,1
          bind=SUPER+CTRL,period,tagmon,right,1

          # Application/Script Binds
          bind=NONE,XF86PowerOff,spawn,wlogout
          bind=SUPER,V,spawn, clipmenu
          bind=SUPER,x,spawn,rice-style action panel
          bind=SUPER,E,spawn,nautilus --new-window
          bind=SUPER,t,spawn,notify-time
          bindc=SUPER+SHIFT,v,spawn,notify-volume
          bind=SUPER,b,spawn,notify-battery
          bind=NONE,Print,spawn,grimblast copy area
          bind=SUPER+SHIFT+ALT,period,spawn,fuzzel-emoji
          bind=SUPER,n,spawn,dm-notes
          bind=SUPER+SHIFT,n,spawn,${terminalCommand} notes
          bind=SUPER,o,spawn,dm-hub
          bind=SUPER+SHIFT,semicolon,spawn,dm-expand
          bind=SUPER,minus,spawn,wtype -k emdash
          bind=SUPER+SHIFT,B,spawn,overskride
          bind=SUPER+CTRL,v,spawn,pwvucontrol
          bind=SUPER+ALT,n,spawn,dm-sunsetr
          bind=SUPER,F1,spawn,gamemode

          bind=SUPER,f,togglemaximizescreen
          bind=SUPER+SHIFT,f,togglefullscreen
          bind=SUPER+ALT,f,togglefakefullscreen
          bind=SUPER+ALT,l,spawn,rice-lock

          # Screenshots
          bind=SUPER,P,spawn,grimpick
          bind=SUPER+SHIFT,S,spawn,grimpick region
          bind=SUPER+SHIFT,P,spawn,grimblast save output
          bind=SUPER+ALT,P,spawn,grimblast save active

          # Media Keys (Volume)
          bind=NONE,XF86AudioRaiseVolume,spawn,rice-style action volume-up
          bind=NONE,XF86AudioLowerVolume, spawn, rice-style action volume-down
          bind=NONE,XF86AudioMute,spawn, rice-style action volume-mute

          # Media Keys (Mic)
          bind=NONE,XF86AudioMicMute,spawn,rice-style action mic-mute
          bindc=SUPER+SHIFT,M,spawn,rice-style action volume-mute

          # Media Keys (Playback)
          bind=NONE,XF86AudioMedia,spawn,playerctl play-pause
          bind=NONE,XF86AudioPlay,spawn,playerctl play-pause
          bind=NONE,XF86AudioPrev,spawn,playerctl previous
          bind=NONE,XF86AudioNext,spawn,playerctl next

          # Media Keys (Brightness)
          bind=NONE,XF86MonBrightnessUp,spawn,rice-style action brightness-up
          bind=NONE,XF86MonBrightnessDown,spawn,rice-style action brightness-down

          # Other Keys

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

          # Layout Switching (Automatically switches key_mode too)
          # bindc runs every command sharing the shortcut.
          bindc=SUPER+SHIFT,T,setlayout,tile
          bindc=SUPER+SHIFT,T,setkeymode,default
          bindc=SUPER+SHIFT,M,setlayout,monocle
          bindc=SUPER+SHIFT,M,setkeymode,monocle
          bindc=SUPER+SHIFT,G,setlayout,grid
          bindc=SUPER+SHIFT,G,setkeymode,grid
          bindc=SUPER+SHIFT,X,setlayout,scroller
          bindc=SUPER+SHIFT,X,setkeymode,scroller
          bindc=SUPER+CTRL+SHIFT,D,setlayout,deck
          bindc=SUPER+CTRL+SHIFT,D,setkeymode,deck
          bindc=SUPER+SHIFT,C,setlayout,center_tile
          bindc=SUPER+SHIFT,C,setkeymode,center_tile
          bindc=SUPER+SHIFT,R,setlayout,right_tile
          bindc=SUPER+SHIFT,R,setkeymode,right_tile
          bindc=SUPER+SHIFT,V,setlayout,vertical_tile
          bindc=SUPER+SHIFT,V,setkeymode,vertical_tile
          bindc=SUPER+CTRL,G,setlayout,vertical_grid
          bindc=SUPER+CTRL,G,setkeymode,vertical_grid
          bindc=SUPER+CTRL,X,setlayout,vertical_scroller
          bindc=SUPER+CTRL,X,setkeymode,vertical_scroller
          bindc=SUPER+CTRL,D,setlayout,vertical_deck
          bindc=SUPER+CTRL,D,setkeymode,vertical_deck
          bindc=SUPER+ALT,T,setlayout,tile
          bindc=SUPER+ALT,T,setkeymode,default
          bindc=SUPER+ALT,M,setlayout,monocle
          bindc=SUPER+ALT,M,setkeymode,monocle
          bindc=SUPER+ALT,X,setlayout,scroller
          bindc=SUPER+ALT,X,setkeymode,scroller

          # Cycle through keymodes
          bind=SUPER+CTRL+SHIFT,S,setkeymode,cycle

          ## Mouse Bindings
          mousebind=SUPER,btn_left,moveresize,curmove
          mousebind=SUPER,btn_right,moveresize,curresize

          # Touchpad Gestures (3-finger)
          gesturebind=NONE,up,3,viewtoright_have_client
          gesturebind=NONE,down,3,viewtoleft_have_client
          gesturebind=NONE,left,3,focusstack,next
          gesturebind=NONE,right,3,focusstack,prev
          gesturebind=SUPER,down,3,killclient
          gesturebind=SUPER,up,3,togglefullscreen
          gesturebind=NONE,up,4,toggle_scratchpad
          gesturebind=NONE,down,4,toggle_scratchpad

          # --- Layout Specific Keymodes ---

          # Tile (Master/Stack, default mode because it is the default layout in tagrules)
          key_mode=default
          bind=SUPER,k,focusstack,prev
          bind=SUPER,j,focusstack,next
          bind=SUPER+SHIFT,k,exchange_stack_client,prev
          bind=SUPER+SHIFT,j,exchange_stack_client,next
          bind=SUPER,equal,setmfact,-0.05
          bind=SUPER+SHIFT,equal,setmfact,+0.05
          bind=SUPER,space,zoom
          bind=SUPER+SHIFT,h,incnmaster,+1
          bind=SUPER+SHIFT,l,incnmaster,-1

          # Scroller
          key_mode=scroller
          bind=SUPER,r,switch_proportion_preset
          bind=SUPER,h,focusdir,left
          bind=SUPER,l,focusdir,right
          bind=SUPER+CTRL,h,exchange_stack_client,prev
          bind=SUPER+CTRL,l,exchange_stack_client,next
          bind=SUPER,j,focusdir, down
          bind=SUPER,k,focusdir, up
          bind=SUPER+SHIFT,j,scroller_stack,down
          bind=SUPER+SHIFT,k,scroller_stack,up
          bind=SUPER+SHIFT,h,scroller_stack,left
          bind=SUPER+SHIFT,l,scroller_stack,right

          # Tile (Master/Stack)
          key_mode=tile
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
          key_mode=monocle
          bind=SUPER,k,focusstack,prev
          bind=SUPER,j,focusstack,next
          bind=SUPER+SHIFT,k,exchange_stack_client,prev
          bind=SUPER+SHIFT,j,exchange_stack_client,next

          # Grid
          key_mode=grid
          bind=SUPER,k,focusdir,up
          bind=SUPER,j,focusdir,down
          bind=SUPER,h,focusdir,left
          bind=SUPER,l,focusdir,right
          bind=SUPER+SHIFT,k,exchange_client,up
          bind=SUPER+SHIFT,j,exchange_client,down
          bind=SUPER+SHIFT,h,exchange_client,left
          bind=SUPER+SHIFT,l,exchange_client,right

          # Deck
          key_mode=deck
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
          key_mode=center_tile
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
          key_mode=right_tile
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
          key_mode=vertical_tile
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
          key_mode=vertical_grid
          bind=SUPER,k,focusdir,up
          bind=SUPER,j,focusdir,down
          bind=SUPER,h,focusdir,left
          bind=SUPER,l,focusdir,right
          bind=SUPER+SHIFT,k,exchange_client,up
          bind=SUPER+SHIFT,j,exchange_client,down
          bind=SUPER+SHIFT,h,exchange_client,left
          bind=SUPER+SHIFT,l,exchange_client,right

          # Vertical Scroller
          key_mode=vertical_scroller
          bind=SUPER,r,switch_proportion_preset
          bind=SUPER,k,focusstack,prev
          bind=SUPER,j,focusstack,next
          bind=SUPER+SHIFT,k,exchange_stack_client,prev
          bind=SUPER+SHIFT,j,exchange_stack_client,next

          # Vertical Deck
          key_mode=vertical_deck
          bind=SUPER,k,focusstack,prev
          bind=SUPER,j,focusstack,next
          bind=SUPER+SHIFT,k,exchange_stack_client,prev
          bind=SUPER+SHIFT,j,exchange_stack_client,next
          bind=SUPER,equal,setmfact,-0.05
          bind=SUPER+SHIFT,equal,setmfact,+0.05
          bind=SUPER,space,zoom
          bind=SUPER+SHIFT,h,incnmaster,+1
          bind=SUPER+SHIFT,l,incnmaster,-1
          exec_once=~/.config/mango/autostart.sh
        '';
        ".config/mango/autostart.sh".source = pkgs.writers.writeBash "autostart.sh" ''
          stash watch &
          xwayland-satellite &
          battery-monitor &
          emacs --daemon &
          rice-style apply &
          nm-applet &
          kanshi &
          sunsetr &
          gomuks-web &
        '';
      };
    };
  };
}
