{ inputs, ... }:
{
  imports = [
    inputs.dm-scripts.nixosModules.default
  ];
  programs.dmscripts = {
    enable = true;

    # Choose your display server dependencies
    displayServer = "wayland";

    # The new option to build and install manpages
    manPages = true;

    # Selectively install scripts, or leave empty/omit to install all
    scripts = [
      "dm-kill"
      "dm-hub"
      "dm-confedit"
      "dm-wifi"
      "dm-websearch"
      "dm-spam"
      "dm-dictionary"
      "dm-spellcheck"
      "dm-documents"
      "dm-dragdir"
      "dm-dragdrop"
      "dm-sunsetr"
    ];
  };
}
