{
  flake.modules.nixos.video = {pkgs, ...}: let
    stremioFixed = pkgs.stremio-linux-shell.overrideAttrs (old: {
      nativeBuildInputs =
        (old.nativeBuildInputs or [])
        ++ [
          pkgs.makeWrapper
        ];

      postFixup =
        (old.postFixup or "")
        + ''
          mv $out/bin/stremio $out/bin/stremio-unwrapped

          makeWrapper ${pkgs.strace}/bin/strace $out/bin/stremio \
            --add-flags "-f" \
            --add-flags "-qq" \
            --add-flags "-o" \
            --add-flags "/dev/null" \
            --add-flags "-e" \
            --add-flags "trace=none" \
            --add-flags "$out/bin/stremio-unwrapped"
        '';
    });
  in {
    environment.systemPackages = with pkgs; [
      ffmpeg
      (mpv.override {scripts = [mpvScripts.mpris];})
      stremioFixed
      kdePackages.qtmultimedia
    ];
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        input-overlay
        obs-livesplit-one
      ];
    };
  };
}
