{
  pkgs,
  inputs,
  lib,
  ...
}: let
  python = pkgs.python3.withPackages (ps: [
    ps.evdev
  ]);

  remarkable-bridge = pkgs.stdenvNoCC.mkDerivation {
    pname = "remarkable-bridge";
    version = "unstable-2026-05-08";

    src = inputs.remarkable-bridge;

    nativeBuildInputs = [
      pkgs.makeWrapper
    ];

    installPhase = ''
            runHook preInstall

            install -Dm755 remarkable_bridge.py \
              $out/share/remarkable-bridge/remarkable_bridge.py

            # avoid crashing if evdev creates the
            # uinput device but cannot reopen the generated /dev/input/eventN.
            substituteInPlace $out/share/remarkable-bridge/remarkable_bridge.py \
              --replace-fail \
                'log.info("virtual %s at %s", mode.name, self._ui.device.path)' \
                'log.info("virtual %s at %s", mode.name, self._ui.device.path if self._ui.device is not None else "<unopened>")'

            makeWrapper ${python}/bin/python $out/bin/remarkable-bridge \
              --add-flags "$out/share/remarkable-bridge/remarkable_bridge.py" \
              --prefix PATH : ${lib.makeBinPath [
        pkgs.openssh
      ]}

            install -Dm644 /dev/stdin \
              $out/lib/udev/rules.d/70-remarkable-bridge.rules <<'EOF'
      # Allow creating uinput devices.
      KERNEL=="uinput", SUBSYSTEM=="misc", GROUP="uinput", MODE="0660", TAG+="uaccess", OPTIONS+="static_node=uinput"

      # Allow python-evdev to reopen the virtual event device it just created.
      # Start broad for debugging; tighten later if desired.
      SUBSYSTEM=="input", KERNEL=="event*", GROUP="uinput", MODE="0660", TAG+="uaccess"
      EOF

            runHook postInstall
    '';

    meta = {
      description = "Use a reMarkable as a Linux tablet input device over SSH";
      homepage = "https://github.com/blwtxc/remarkable-bridge";
      license = lib.licenses.asl20;
      mainProgram = "remarkable-bridge";
    };
  };
in {
  environment.systemPackages = [
    remarkable-bridge
  ];

  hardware.uinput.enable = true;

  boot.kernelModules = [
    "uinput"
  ];

  users.groups.uinput = {};

  users.users.soliprem.extraGroups = [
    "uinput"
  ];

  services.udev.packages = [
    remarkable-bridge
  ];
}
