{lib, ...}: {
  hjem.users.soliprem.files = {
    ".gitconfig".text = lib.generators.toGitINI {
      user = {
        email = "franci.solidoro@gmail.com";
        name = "Soliprem";
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
