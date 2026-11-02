{
  stdenv,
  fetchFromGitHub,
  zig_0_16,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  wayland,
  libxkbcommon,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kwim";
  version = "0.2.1-dev";

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwim";
    rev = "becc1284ccc8c5abdfb8a117b561a97f4448e9dd";
    hash = "sha256-Ob59H1535EYReXMCERdlTNfhwv2GGBCSCmvfIeJzzzo=";
  };

  zigDeps = zig_0_16.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-rOZZu/Y/rZ7who3hl1qIBHXZtRP7s4FXo0+LNnM6dYo=";
  };

  nativeBuildInputs = [zig_0_16 pkg-config wayland-scanner];
  buildInputs = [wayland wayland-protocols libxkbcommon];

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';
})
