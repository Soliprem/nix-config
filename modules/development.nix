{
  flake.modules.nixos.development = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      codex
      t3code
      zk
      graphviz
      pijul
      gdb
      jujutsu
      typst
      tinymist
      (texliveSmall.withPackages (ps: [ps.dvipng]))
      zed-editor
    ];
  };
}
