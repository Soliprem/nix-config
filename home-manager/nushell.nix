{
  programs = {
    nushell = {
      enable = true;
      configFile.text = ''
        $env.config = {
          show_banner: false
          edit_mode: vi
          }
        greeting
          '';
      shellAliases = {
        # Verbosity and settings that you pretty much just always are going to want.
        river="XKB_DEFAULT_LAYOUT=it river";
        # rcow="fortune | cowsay -r | lolcat";
        cp="cp -iv";
        nnn="nnn -e";
        mv="mv -iv";
        rm="rm -vI";
        bc="bc -ql";
        # rg="cd .steam/steam/steamapps/compatdata/813780/pfx/drive_c/users/steamuser/Games/Age\ of\ Empires\ 2\ DE/76561199050658286/savegame";
        # mkd="mkdir -pv";
        yt="yt-dlp --embed-metadata -i";
        yta="yt -x -f bestaudio/best";
        ffmpeg="ffmpeg -hide_banne";
        # Colorize commands when possible.;
        # ls="exa --header --icons --group-directories-first";
        nvimtutor="nvim -c Tutor";
        cat="bat";
        # ll="exa --long --header --icons --color-scale all --group-directories-first";
        # l="exa --long --header --icons --color-scale all --group-directories-first";
        nn="cd ~/.config/nvim/; ls";
        grep="grep --color=auto";
        diff="diff --color=auto";
        ccat="highlight --out-format=ansi";
        ip="ip -color";
        # These common commands are just too long! Abbreviate them.;
        ka="killall";
        g="git";
        trem="transmission-remote";
        YT="youtube-viewer";
        sdn="shutdown -h now";
        e="nvim";
        v="nvim";
        p="pacman";
        xi="sudo xbps-install";
        xr="sudo xbps-remove -R";
        xq="xbps-query";
        config="/usr/bin/git --git-dir=/home/soliprem/.cfg/ --work-tree=/home/soliprem";
        cd="z";
        z="zathura";
        "cd.."="cd ..";
        lf="lfub";
        magit="nvim -c MagitOnly";
        cac="cd $'($env.HOME)/.cache'; ls -a";
        cf="cd $'($env.HOME)/.config'; ls -a";
        D="cd $'($env.HOME)/Downloads'; ls -a";
        i="cd /home/soliprem/Images; ls -a";
        d="cd $'($env.HOME)/Documents'; ls -a";
        dt="cd $'($env.HOME)/.local/share'; ls -a";
        rr="cd $'($env.HOME)/.local/src'; ls -a";
        h="cd $env.HOME; ls -a";
        m="cd $'($env.HOME)/Music'; ls -a";
        mn="cd /mnt; ls -a";
        pp="cd $'($env.HOME)/Pictures'; ls -a";
        sc="cd $'($env.HOME)/.local/bin'; ls -a";
        src="cd $'($env.HOME)/.local/src'; ls -a";
        vv="cd $'($env.HOME)/Videos'; ls -a";
        # bf="$env.EDITOR $'($env.HOME)/.config/shell/bm-files'";
        # bd="$env.EDITOR $'($env.HOME)/.config/shell/bm-dirs'";
        # cfx="$env.EDITOR $'($env.HOME)/.config/x11/xresources'";
        # cfb="$env.EDITOR ~/.local/src/dwmblocks/config.h";
        # cfv="$env.EDITOR $'($env.HOME)/.config/nvim/init.vim'";
        # cfz="$env.EDITOR $'($env.HOME)/.config/zsh/.zshrc'";
        # cfa="$env.EDITOR $'($env.HOME)/.config/shell/aliasrc'";
        # cfp="$env.EDITOR $'($env.HOME)/.config/shell/profile'";
        # cfm="$env.EDITOR $'($env.HOME)/.config/mutt/muttrc'";
        # cfn="$env.EDITOR $'($env.HOME)/.config/newsboat/config'";
        # cfu="$env.EDITOR $'($env.HOME)/.config/newsboat/urls'";
        # cfmb="$env.EDITOR $'($env.HOME)/.config/ncmpcpp/bindings'";
        # cfmc="$env.EDITOR $'($env.HOME)/.config/ncmpcpp/config'";
        # cfl="$env.EDITOR $'($env.HOME)/.config/lf/lfrc'";
        # cfL="$env.EDITOR $'($env.HOME)/.config/lf/scope'";
        # cfX="$env.EDITOR $'($env.HOME)/.config/sxiv/exec/key-handler'";
        };
        };
      zoxide = {
        enable = true;
        enableNushellIntegration = true;
        };
      eza = {
        enable = true;
        # enableNushellIntegration = true;
        };
      yazi = {
        enable = true;
        enableNushellIntegration = true;
        };
      starship = {
        enable = true;
        enableNushellIntegration = true;
        };
  };
}
