{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
}:
buildGoModule (finalAttrs: {
  pname = "mautrix-telegram";
  version = "0.2611.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z3jfjQyh47scBjHNThLn5DluSSS4fT21NAibWyD5Iqc=";
  };

  vendorHash = "sha256-byvTXR7gy6b/TIVfJ8bwMC/D9vqn6iwjoxBE1gkBNBc=";

  subPackages = ["cmd/mautrix-telegram"];
  buildInputs = [olm];
  ldflags = ["-s" "-w" "-X" "main.Tag=v${finalAttrs.version}"];

  meta = {
    description = "Matrix-Telegram puppeting bridge";
    homepage = "https://github.com/mautrix/telegram";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "mautrix-telegram";
  };
})
