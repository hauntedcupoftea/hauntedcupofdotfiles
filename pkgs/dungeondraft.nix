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
}:
stdenv.mkDerivation rec {
  pname = "Dungeondraft";
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
    mkdir -p $out/bin
    cp -R usr/share opt $out/
    mkdir -p $out/share/icons/hicolor/256x256/apps
    mv $out/opt/Dungeondraft/Dungeondraft.png $out/share/icons/hicolor/256x256/apps/Dungeondraft.png
    ln -s $out/opt/Dungeondraft/Dungeondraft.x86_64 $out/bin/Dungeondraft.x86_64
    substituteInPlace \
      $out/share/applications/Dungeondraft.desktop \
        --replace-warn /opt/Dungeondraft/ "" \
        --replace-warn Dungeondraft.png Dungeondraft \
        --replace-warn /opt/Dungeondraft $out/opt/Dungeondraft
    runHook postInstall
  '';
  postInstall = ''
    wrapProgram $out/bin/Dungeondraft.x86_64 \
      --prefix PATH : ${lib.makeBinPath [zenity]}
  '';
  postFixup = ''
    patchelf \
      --add-needed ${udev}/lib/libudev.so.1 \
      --add-needed ${alsa-lib}/lib/libasound.so.2 \
      $out/opt/Dungeondraft/Dungeondraft.x86_64
  '';

  meta = {
    homepage = "https://dungeondraft.net/";
    description = "Mapmaking tool for Tabletop Roleplaying Games, designed for battlemap scale";
    license = lib.licenses.unfree;
    platforms = ["x86_64-linux"];
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    mainProgram = "Dungeondraft.x86_64";
  };
}
