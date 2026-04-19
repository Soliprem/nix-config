{lib, ...}: {
  files = {
    ".gitconfig".text = lib.generators.toGitINI {
      commit = {
        gpgSign = true;
      };
      user = {
        email = "franci.solidoro@gmail.com";
        name = "Soliprem";
        signingKey = "4FD6B0D51C9AB6BD";
      };
      url = {
        "ssh://git@github.com/" = {
          insteadOf = [
            "https://github.com/"
            "gh:"
          ];
        };
      };
    };
  };
}
