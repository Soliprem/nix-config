{
  flake.modules.nixos.development = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      codex
      claude-code
      t3code
      antigravity-cli
      antigravity-acp
      zk
      graphviz
      pijul
      gdb
      jujutsu
      typst
      tinymist
      (texliveSmall.withPackages (ps: [ps.dvipng]))
    ];
  };
}
