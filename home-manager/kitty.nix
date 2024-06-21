{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;
      initial_window_width = 1200;
      initial_window_height = 600;
      update_check_interval = 0;
      enable_audio_bell = false;
      confirm_os_window_close = "0";
      remember_window_size = "no";
      disable_ligatures = "never";
      shell = "${pkgs.tmux}/bin/tmux";
      url_style = "curly";
      cursor_shape = "Underline";
      cursor_underline_thickness = config.var.theme.border-size;
      window_padding_width = config.var.theme.gaps-in;

      # Font
      font_family = config.var.theme.font-mono;
      font_size = config.var.theme.font-size;

    };
  };
}
