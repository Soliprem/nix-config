{ pkgs, ... }:
{
  users.users.soliprem = {
    isNormalUser = true;
    description = "Francesco Prem Solidoro";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.bash;
  };

  environment.shells = [
    pkgs.nushell
  ];

  programs.bash.interactiveShellInit = ''
    if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ] && [ -z "$IN_NIX_SHELL" ];
    then
      exec nu
    fi
  '';
}
