{
  inputs,
  ...
}:

{
  formatter = inputs.nixpkgs.legacyPackages.x86_64-linux.alejandra;

  # Check if codebase is properly formatted.
  # This can be initiated with `nix build .#checks.<system>.nix-fmt`
  # or with `nix flake check`
  checks = {
    nix-fmt = inputs.nixpkgs.legacyPackages.x86_64-linux.runCommand "nix-fmt-check" {
      nativeBuildInputs = [inputs.nixpkgs.legacyPackages.x86_64-linux.alejandra];
    } ''
      alejandra --check ${../.} < /dev/null | tee $out
    '';
  };
}
