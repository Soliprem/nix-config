{
  lib,
  gst_all_1,
  stdenv,
  src,
  version,
  pkgs,
  autoPatchelfHook,
  makeWrapper,
  addDriverRunpath,
}: let
  gstPlugins = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ];

  runtimeLibs = with pkgs; [
    glib-networking
    librsvg
    libgbm

    # Do NOT put gst_all_1 here; it's an attrset.

    glib
    gtk3
    gdk-pixbuf
    nss
    nspr
    at-spi2-atk
    dbus
    cups
    expat
    cairo
    pango
    libxkbcommon
    systemd
    alsa-lib
    libGL

    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb

    libayatana-appindicator
    libpulseaudio
    pipewire
  ];

  ldLibraryPath = lib.concatStringsSep ":" [
    (lib.makeLibraryPath runtimeLibs)
    "${addDriverRunpath.driverLink}/lib"
    "$out/lib/sable/runtime"
  ];
in
  stdenv.mkDerivation {
    pname = "sable-bin";
    inherit version src;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = runtimeLibs;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir unpack
      tar -xzf "$src" -C unpack

      mkdir -p "$out/lib/sable"

      install -Dm755 \
        unpack/sable \
        "$out/lib/sable/sable"

      cp -a \
        unpack/runtime \
        "$out/lib/sable/runtime"

      # Desktop file + icons supplied by upstream.
      mkdir -p "$out/share"
      cp -a unpack/share/. "$out/share/"

      mkdir -p "$out/bin"

      makeWrapper \
        "$out/lib/sable/sable" \
        "$out/bin/sable" \
        --prefix LD_LIBRARY_PATH : "${ldLibraryPath}" \
        --prefix PATH : "${lib.makeBinPath [
        pkgs.desktop-file-utils
        pkgs.xdg-utils
      ]}" \
        --set GIO_EXTRA_MODULES \
          "${pkgs.glib-networking}/lib/gio/modules" \
        --set GDK_PIXBUF_MODULE_FILE \
          "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
        --set GST_PLUGIN_SYSTEM_PATH_1_0 \
          "${lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gstPlugins}"

      runHook postInstall
    '';

    preFixup = ''
      addAutoPatchelfSearchPath "$out/lib/sable/runtime"
    '';

    meta = {
      description = "Sable Matrix client";
      homepage = "https://github.com/SableClient/Sable";
      mainProgram = "sable";
      platforms = ["x86_64-linux"];
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
