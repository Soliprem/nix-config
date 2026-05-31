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
