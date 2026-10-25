{config, ...}: {
  flake.modules.nixos.shells.imports = with config.flake.modules.nixos; [
    envModule
    shellTools
    bitwardenModule
    fastfetchModule
    gitModule
    starshipModule
    fishModule
    nushellModule
    zshModule
  ];
}
