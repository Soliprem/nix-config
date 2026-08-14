{
  lib,
  requireFile,
  stdenvNoCC,
  unzip,
}: let
  version = "14.365.0";
in
  stdenvNoCC.mkDerivation {
    pname = "foundry-vtt";
    inherit version;

    src = requireFile {
      name = "foundryvtt-14.365.zip";
      sha256 = "sha256-T6T0RxDwAe2ZMx9a9JHOHebcH1TDKd4EeX/jvmmOyRY=";
      message = ''
        Foundry VTT is licensed software and must be supplied manually.
        Add the v14.365 Linux/Node.js archive with:
          nix-store --add-fixed sha256 foundryvtt-14.365.zip
      '';
    };

    nativeBuildInputs = [unzip];
    dontUnpack = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      unzip -q "$src" -d "$out"
      runHook postInstall
    '';

    meta = {
      description = "Foundry Virtual Tabletop server";
      homepage = "https://foundryvtt.com/";
      mainProgram = "main.js";
      platforms = ["x86_64-linux"];
      sourceProvenance = [lib.sourceTypes.binaryBytecode];
    };
  }
