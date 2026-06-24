{
  src,
  pkgs,
  lib,
  stdenv,
  makeWrapper,
  makeFontsConf,
}: let
  runtimeDeps = with pkgs; [
    fish
    ddcutil
    brightnessctl
    app2unit
    cava
    networkmanager
    lm_sensors
    grim
    swappy
    wl-clipboard
    libqalculate
    quickshell
    inotify-tools
    bluez
    bash
    hyprland
  ];
  fontconfig = makeFontsConf {
    fontDirectories = [pkgs.material-symbols];
  };
in
  stdenv.mkDerivation (final: {
    inherit src;

    pname = "caelestia-shell";
    version = "${final.src.rev}";

    nativeBuildInputs = [pkgs.gcc makeWrapper];
    buildInputs = with pkgs; [quickshell aubio pipewire];
    propogatedBuildInputs = runtimeDeps;

    buildPhase = ''
      mkdir -p bin
      g++ -std=c++17 -Wall -Wextra \
          -I${pkgs.pipewire.dev}/include/pipewire-0.3 \
          -I${pkgs.pipewire.dev}/include/spa-0.2 \
          -I${pkgs.aubio}/include/aubio \
          assets/beat_detector.cpp \
          -o bin/beat_detector \
          -lpipewire-0.3 -laubio
    '';

    installPhase = ''
      install -Dm755 bin/beat_detector $out/bin/beat_detector
      makeWrapper ${pkgs.quickshell}/bin/quickshell $out/bin/caelestia-shell \
          --prefix PATH : "${lib.makeBinPath runtimeDeps}" \
          --set FONTCONFIG_FILE "${fontconfig}" \
          --set CAELESTIA_BD_PATH $out/bin/beat_detector \
          --add-flags '-p ${src}'
    '';

    meta = {
      description = "A very segsy desktop shell";
      homepage = "https://github.com/caelestia-dots/shell";
      license = lib.licenses.gpl3Only;
      mainProgram = "caelestia-shell";
    };
  })
