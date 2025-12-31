_: {
  files = {
    ".config/nushell/config.nu".text = /* nu */ ''
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

      try { open ~/.cache/sequences.txt | print } catch { }
      greeting

      use ~/.cache/starship/init.nu
      source ~/.cache/zoxide/init.nu
      source ~/.cache/niri/completions.nu
      source ~/.cache/carapace/init.nu
      source ~/.cache/atuin/init.nu
      source ~/.cache/nix_your_shell/nix-your-shell.nu


      alias D = cd $'($env.HOME)Downloads'; ls -a
      alias nd = nix develop
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
    '';

    ".config/nushell/env.nu".text = /* nu */ ''
      def ensure-cache [path: path, cmd: closure] {
              if not ($path | path dirname | path exists) {
                  mkdir ($path | path dirname)
              }
              do $cmd | save -f $path
            }

            ensure-cache ($env.HOME + "/.cache/nix_your_shell/nix-your-shell.nu") { nix-your-shell nu }
            ensure-cache ($env.HOME + "/.cache/starship/init.nu") { starship init nu }
            ensure-cache ($env.HOME + "/.cache/carapace/init.nu") { carapace _carapace nushell }
            ensure-cache ($env.HOME + "/.cache/atuin/init.nu") { atuin init nu }
            ensure-cache ($env.HOME + "/.cache/zoxide/init.nu") { zoxide init nushell --cmd cd }
            ensure-cache ($env.HOME + "/.cache/niri/completions.nu") { niri completions nushell }

            load-env {}
    '';

    ".config/nushell/scripts.nu".text = /* nu */ ''
      def deflate [archive, output_dir] {
         let archive = (zipinfo -1 $archive | lines | reverse)
         cd ($output_dir | default ".")
         $archive | rm ...$in
      }
    '';
  };
}
