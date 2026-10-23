{inputs, ...}: {
  flake.modules.nixos.doom = {
    pkgs,
    system,
    ...
  }: {
    age.secrets = {
      gonic_authinfo = {
        file = ../../secrets/gonic_authinfo.age;
        owner = "soliprem";
        mode = "400";
      };
      gomuks_authinfo = {
        file = ../../secrets/gomuks_authinfo.age;
        owner = "soliprem";
        mode = "400";
      };
    };
    environment.systemPackages = with pkgs; [
      inputs.self.packages.${system}.doom-emacs
      ispell
    ];
  };
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    doomPkgs = pkgs.extend inputs.nix-doom-emacs-unstraightened.overlays.default;
    isyncOauth = inputs.self.packages.${system}.isync-oauth;
  in {
    packages.doom-emacs = doomPkgs.emacsWithDoom {
      emacs = doomPkgs.emacs-pgtk;
      doomDir = ./doom;
      doomLocalDir = "~/.local/share/nix-doom";
      emacsPackageOverrides = _: epkgs: {
        julia-snail = epkgs.julia-snail.overrideAttrs (old: {
          postPatch =
            (old.postPatch or "")
            + ''
                    cat >> extensions/formatter/Project.toml <<'EOF'

              [compat]
              JuliaFormatter = "=1.0.62"
              EOF
            '';
        });
      };
      extraPackages = epkgs: [
        (epkgs.treesit-grammars.with-grammars (grammars: [
          grammars.tree-sitter-typst
          # julia-ts-mode's queries target grammar v0.23.1.
          (grammars.tree-sitter-julia.override {
            version = "0.23.1";
            src = doomPkgs.fetchFromGitHub {
              owner = "tree-sitter";
              repo = "tree-sitter-julia";
              rev = "v0.23.1";
              hash = "sha256-jwtMgHYSa9/kcsqyEUBrxC+U955zFZHVQ4N4iogiIHY=";
            };
          })
        ]))
      ];
      extraBinPackages = with doomPkgs; [
        fd
        git
        isyncOauth
        (mpv.override {scripts = [mpvScripts.mpris];})
        msmtp
        oama
        ripgrep
        tinymist
        typst
      ];
    };
  };
}
