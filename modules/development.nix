{inputs, ...}: {
  flake.modules.nixos.development = {pkgs, ...}: let
    sys = pkgs.stdenv.hostPlatform.system;
  in {
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
      inputs.deploy-rs.packages.${sys}.default
    ];
  };
}
