_: {
  files = {
    ".config/nushell/config.nu".text = ''
      $env.config = {
          show_banner: false
          edit_mode: vi
          rm: {always_trash: true}
          keybindings: [
            {
              name: history_completion
              modifier: control
              keycode: char_f
              mode: [vi_normal, vi_insert]
              event: { send: HistoryHintComplete }
            }
            {
              name: history_completion
              modifier: Control_Shift
              keycode: char_f
              mode: [vi_normal, vi_insert]
              event: { send: HistoryHintWordComplete }
            }
          ]
        }
      let fish_completer = {|spans|
        fish --command $'complete "--do-complete=($spans | str join " ")"'
        | $"value(char tab)description(char newline)" + $in
        | from tsv --flexible --no-infer
      }
      try {
          open ~/.cache/sequences.txt | print
      } catch {
          # Silently ignore if file doesn't exist (equivalent to 2> /dev/null)
      }
      greeting

      $env.config.color_config = {
        separator: "#e48740"
        leading_trailing_space_bg: "#deaeb0"
        header: "#978e6e"
        date: "#5e999a"
        filesize: "#629f7e"
        row_index: "#c37ca1"
        bool: "#e16e3c"
        int: "#978e6e"
        duration: "#e16e3c"
        range: "#e16e3c"
        float: "#e16e3c"
        string: "#deaeb0"
        nothing: "#e16e3c"
        binary: "#e16e3c"
        cellpath: "#e16e3c"
        hints: dark_gray

        shape_garbage: { fg: "#f1f2f8" bg: "#e16e3c" }
        shape_bool: "#629f7e"
        shape_int: { fg: "#5e999a" attr: b }
        shape_float: { fg: "#5e999a" attr: b }
        shape_range: { fg: "#898f97" attr: b }
        shape_internalcall: { fg: "#c37ca1" attr: b }
        shape_external: "#c37ca1"
        shape_externalarg: { fg: "#978e6e" attr: b }
        shape_literal: "#629f7e"
        shape_operator: "#898f97"
        shape_signature: { fg: "#978e6e" attr: b }
        shape_string: "#978e6e"
        shape_filepath: "#629f7e"
        shape_globpattern: { fg: "#629f7e" attr: b }
        shape_variable: "#5e999a"
        shape_flag: { fg: "#629f7e" attr: b }
        shape_custom: { attr: b }
      }

      use ~/.cache/starship/init.nu

      source ~/.cache/carapace/init.nu

      source ~/.cache/atuin/init.nu
      source ~/.cache/nix_your_shell/nix-your-shell.nu

      alias D = cd $'($env.HOME)Downloads'; ls -a
      alias sl = sll
      alias fg = job unfreeze
      alias ,, = , (history | last | get command)
      alias lg = lazygit
      alias YT = youtube-viewer
      alias bc = bc -ql
      alias cac = cd $'($env.HOME)/.cache'; ls -a
      alias cat = bat
      alias ccat = highlight --out-format=ansi
      alias cd.. = cd ..
      alias cf = cd $'($env.HOME)/.config'; ls -a
      alias config = /usr/bin/git --git-dir=$'($env.HOME)/.cfg/' --work-tree=$'($env.HOME)'
      alias cp = cp -v
      alias d = cd $'($env.HOME)/Documents'; ls -a
      alias diff = diff --color=auto
      alias dt = cd $'($env.HOME)/.local/share'; ls -a
      alias e = nvim
      alias g = git
      alias grep = grep --color=auto
      alias h = cd $env.HOME; ls -a
      alias i = cd $'($env.HOME)/Images'; ls -a
      alias ip = ip -color
      alias ka = killall
      alias l = ls -l
      alias lf = lfub
      alias m = cd $'($env.HOME)/Music'; ls -a
      alias magit = nvim -c MagitOnly
      alias mn = cd /mnt; ls -a
      alias mv = mv -iv
      alias n = cd ~/.config/nix-config; ls
      alias nn = cd ~/.config/nvim/; ls
      alias nnn = nnn -e
      alias nvimtutor = nvim -c Tutor
      alias p = pacman
      alias pp = cd $'($env.HOME)/Pictures'; ls -a
      alias rm = rm -v
      alias rr = cd $'($env.HOME)/.local/src'; ls -a
      alias sc = cd $'($env.HOME)/.local/bin'; ls -a
      alias sdn = shutdown -h now
      alias src = cd $'($env.HOME)/.local/src'; ls -a
      alias trem = transmission-remote
      alias v = nvim
      alias vv = cd $'($env.HOME)/Videos'; ls -a
      alias xi = sudo xbps-install
      alias xq = xbps-query
      alias xr = sudo xbps-remove -R
      alias yt = yt-dlp --embed-metadata -i
      alias yta = yt -x -f bestaudio/best
      alias z = zathura

      source ~/.cache/zoxide/init.nu
      source ~/.cache/niri/completions.nu
    '';

    ".config/nushell/env.nu".text = ''
      let nix_your_shell_cache = $'($env.HOME)/.cache/nix_your_shell'
      if not ($nix_your_shell_cache | path exists) {
        mkdir $nix_your_shell_cache
      }
      nix-your-shell nu | save -f $'($nix_your_shell_cache)/nix-your-shell.nu'

      let starship_cache = $'($env.HOME)/.cache/starship'
      if not ($starship_cache | path exists) {
        mkdir $starship_cache
      }
      starship init nu | save --force $'($env.HOME)/.cache/starship/init.nu'

      let carapace_cache = $'($env.HOME)/.cache/carapace'
      if not ($carapace_cache | path exists) {
        mkdir $carapace_cache
      }
      carapace _carapace nushell | save -f $"($carapace_cache)/init.nu"

      let atuin_cache = $'($env.HOME)/.cache/atuin'
      if not ($atuin_cache | path exists) {
        mkdir $atuin_cache
      }
      atuin init nu  | save --force $'($env.HOME)/.cache/atuin/init.nu'

      let zoxide_cache = $'($env.HOME)/.cache/zoxide'
      if not ($zoxide_cache | path exists) {
        mkdir $zoxide_cache
      }
      zoxide init nushell --cmd cd |
        save --force $'($env.HOME)/.cache/zoxide/init.nu'
      
      let niri_cache = $'($env.HOME)/.cache/niri'
      if not ($niri_cache | path exists) {
        mkdir $niri_cache
      }
      niri completions nushell | save -f $'($env.HOME)/.cache/niri/completions.nu'

      load-env {}
    '';

    ".config/nushell/scripts.nu".text = ''
      def deflate [archive, output_dir] {
         let archive = (zipinfo -1 $archive | lines | reverse)
         cd ($output_dir | default ".")
         $archive | rm ...$in
      }
    '';
  };
}
