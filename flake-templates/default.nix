{
  devshell = {
    path = ./devshell;
    description = "Simple Flake with a Devshell";
    welcomeText = ''
      # Devshell Flake template

      ## TO-DO
      - Just change the packages and jump in
    '';
  };
  rust = {
    path = ./rust;
    description = "Opinionated Rust flake";
    welcomeText = ''
      # Rust Flake template
      ## Features
      - naersk for faster build times
      - fenix for nightly toolchain

      ## TO-DO
      - Run `cargo init` to initialise your project
    '';
  };
  ocaml = {
    path = ./ocaml;
    description = "OCaml flake with dune";
    welcomeText = ''
      # OCaml Flake template
      ## Features
      - dune build, ocaml-lsp, ocamlformat and utop in the devshell
      - the same library list for the package and the devshell

      ## TO-DO
      - Run `dune init project <name> .` to initialise your project
      - Set `pname` in flake.nix to `<name>`
      - Add libraries to `buildInputs`
    '';
  };
  julia = {
    path = ./julia;
    description = "Simple Julia Flake";
    welcomeText = ''
      # Julia Flake template
      ## Features
      - handles julia packages

      ## TO-DO
      - edit the required packages
    '';
  };
}
