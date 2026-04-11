_: {
  files = {
    ".config/fish/config.fish".text = /* fish */ ''
      if status is-interactive
          set fish_greeting
      end

      starship init fish | source

      if test -f ~/.cache/sequences.txt 
          command cat ~/.cache/sequences.txt 
      end

      set -g fish_greeting
      set -g fish_key_bindings fish_hybrid_key_bindings
      greeting

      zoxide init --cmd cd fish | source
    '';

    ".config/fish/functions/gd.fish".text = /* fish */ ''
      function gd
          cd (command ls -d */ | fzf) || echo error
      end
    '';

    ".config/fish/functions/bw-session.fish".text = /* fish */ ''
      function bw-session
          set -l bw_session (command bw-export-session | string trim)
          if test -n "$bw_session"
              set -gx BW_SESSION $bw_session
          end
      end
    '';

    ".config/fish/functions/wd.fish".text = /* fish */ ''
      function wd
          if test -n "$argv"
              cd "$HOME/.local/src/$argv" || echo error
          else
              cd "$HOME"/.local/src/(find "$HOME"/.local/src/*/ -type d -not -path "*/.git*" | cut -d "/" -f6- | fzf) || echo error
          end
      end
    '';

    ".config/fish/functions/fish_prompt.fish".text = /* fish */ ''
      function fish_prompt
          if test -n "$SSH_TTY"
              echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
          end

          echo -n (set_color blue)(prompt_pwd)' '

          set_color -o
          if fish_is_root_user
              echo -n (set_color red)'# '
          end
          echo -n (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '
          set_color normal
      end
    '';

    ".config/fish/functions/fish_right_prompt.fish".text = /* fish */ ''
      function fish_right_prompt
          sleep .05
          mommy -1 -s $status
      end
    '';
  };
}
