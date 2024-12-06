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
      shell = "nu";
      url_style = "curly";
      cursor_shape = "Underline";

    };
  };
}
