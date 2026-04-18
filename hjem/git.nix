{
  gitSigningKey,
  lib,
  ...
}: {
  files = {
    ".gitconfig".text = lib.generators.toGitINI {
      commit = {
        gpgSign = true;
      };
      user = {
        email = "franci.solidoro@gmail.com";
        name = "Soliprem";
        signingKey = gitSigningKey;
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
