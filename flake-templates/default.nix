{
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
}
