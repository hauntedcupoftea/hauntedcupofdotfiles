{
  stdenv,
  lib,
  requireFile,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  libGL,
  libkrb5,
  xorg,
  zlib,
  alsa-lib,
  udev,
  zenity,
  xdg-user-dirs,
}:
stdenv.mkDerivation rec {
  pname = "dungeondraft";
  version = "1.2.0.1";

  src = requireFile {
    name = "Dungeondraft-${version}-Linux64.deb";
    url = "https://dungeondraft.net/";
    hash = "sha256-UvvUCQ1RkhwBPMet/zD0JjI7DPbF4ixzOX85Fi3v/BE=";
  };

  sourceRoot = ".";
  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libGL
    libkrb5
    xorg.libXcursor
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXi
    xorg.libXinerama
    zlib
  ];

  installPhase = ''
        runHook preInstall

        # Create necessary directories
        mkdir -p $out/bin
        mkdir -p $out/share/applications
        mkdir -p $out/share/icons/hicolor/256x256/apps
        mkdir -p $out/opt

        # Copy application files
        cp -R opt/Dungeondraft $out/opt/

        # Copy icon to proper location (from source, not $out)
        cp opt/Dungeondraft/Dungeondraft.png $out/share/icons/hicolor/256x256/apps/Dungeondraft.png

        # Create wrapper script with proper PATH
        makeWrapper $out/opt/Dungeondraft/Dungeondraft.x86_64 $out/bin/dungeondraft \
          --prefix PATH : ${lib.makeBinPath [zenity xdg-user-dirs]} \
          --chdir $out/opt/Dungeondraft

        # Create desktop entry that uses the wrapper
        cat > $out/share/applications/dungeondraft.desktop <<EOF
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Dungeondraft
    Comment=Mapmaking tool for Tabletop Roleplaying Games
    Exec=$out/bin/dungeondraft
    Icon=Dungeondraft
    Terminal=false
    Categories=Graphics;2DGraphics;
    StartupWMClass=Dungeondraft
    EOF

        runHook postInstall
  '';

  postFixup = ''
    patchelf \
      --add-needed ${udev}/lib/libudev.so.1 \
      --add-needed ${alsa-lib}/lib/libasound.so.2 \
      $out/opt/Dungeondraft/Dungeondraft.x86_64
  '';

  meta = with lib; {
    homepage = "https://dungeondraft.net/";
    description = "Mapmaking tool for Tabletop Roleplaying Games, designed for battlemap scale";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    mainProgram = "dungeondraft";
  };
}
