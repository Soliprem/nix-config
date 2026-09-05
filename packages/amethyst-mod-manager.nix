{
  cargo,
  lib,
  meson,
  ninja,
  pkg-config,
  python3,
  qt6,
  rustc,
  rustPlatform,
  sqlite,
  src,
  liblootSrc,
}: let
  libloot = python3.pkgs.buildPythonPackage {
    pname = "libloot";
    version = "0.29.6";
    pyproject = true;
    src = liblootSrc;
    sourceRoot = "source/python";
    cargoRoot = "..";

    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${liblootSrc}/Cargo.lock";
    };
    env.CARGO_TARGET_DIR = "target";

    nativeBuildInputs = with rustPlatform; [
      cargoSetupHook
      maturinBuildHook
    ];

    pythonImportsCheck = ["loot"];
  };
  pythonDeps =
    (with python3.pkgs; [
      bsdiff4
      certifi
      cryptography
      jeepney
      keyring
      lz4
      msgpack
      pillow
      py7zr
      pyside6
      requests
      secretstorage
      shiboken6
      zstandard
    ])
    ++ [libloot];
in
  python3.pkgs.buildPythonApplication {
    pname = "amethyst-mod-manager";
    version = "2.4.0";
    pyproject = false;
    inherit src;

    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${src}/native/amethyst_filegraph/Cargo.lock";
    };
    cargoRoot = "native/amethyst_filegraph";

    nativeBuildInputs = [
      cargo
      meson
      ninja
      pkg-config
      qt6.wrapQtAppsHook
      rustc
      rustPlatform.cargoSetupHook
    ];

    buildInputs = [
      qt6.qtbase
      qt6.qtwayland
      sqlite
    ];

    dependencies = pythonDeps;

    postPatch = ''
      patchShebangs src/version.py
      substituteInPlace amethyst-mod-manager amethyst-mod-manager-cli \
        --replace-fail 'exec python3' 'exec ${python3.interpreter}'
    '';

    preConfigure = ''
      export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
      export CARGO_TARGET_DIR=$PWD/native/amethyst_filegraph/target
      cargo build --frozen --release --all-features \
        --manifest-path native/amethyst_filegraph/Cargo.toml
      cp "$CARGO_TARGET_DIR/release/libamethyst_filegraph.so" \
        src/amethyst_filegraph.abi3.so
    '';

    dontWrapPythonPrograms = true;
    dontWrapQtApps = true;
    postFixup = ''
      for program in amethyst-mod-manager amethyst-mod-manager-cli; do
        wrapProgram "$out/bin/$program" \
          --prefix PYTHONPATH : "$out/${python3.sitePackages}:${python3.pkgs.makePythonPath pythonDeps}" \
          "''${qtWrapperArgs[@]}"
      done
    '';

    pythonImportsCheck = [
      "amethyst_filegraph"
      "app_bootstrap"
      "loot"
    ];

    meta = {
      description = "Linux native mod manager for a variety of games";
      homepage = "https://github.com/ChrisDKN/Amethyst-Mod-Manager";
      license = lib.licenses.gpl3Only;
      mainProgram = "amethyst-mod-manager";
      platforms = lib.platforms.linux;
    };
  }
