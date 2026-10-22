{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "calino";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "Ivan-Malinovski";
    repo = "calino";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jmprIOhVKAMm7a6nTE/BCQ2pslfUELMeN0hcAZDi2mU=";
  };

  nativeBuildInputs = [nodejs pnpm_10 pnpmConfigHook];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-VB/DQoqIv5OWmoSqBr0LEHxtxrG9C/4MUPUu8N+9up4=";
  };

  env = {
    VITE_SITE_URL = "https://calendar.soliprem.eu";
    CALINO_SELF_HOSTED = "true";
  };

  buildPhase = ''
    runHook preBuild
    pnpm exec vite build
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    cp -r dist "$out"
    runHook postInstall
  '';

  meta = {
    description = "CalDAV and CardDAV web client";
    homepage = "https://github.com/Ivan-Malinovski/calino";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
