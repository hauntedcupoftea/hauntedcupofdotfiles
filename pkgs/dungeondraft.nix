{
  lib,
  stdenv,
  requireFile,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  zenity,
  xdg-utils,
  xdg-desktop-portal,
  alsa-lib,
  libGL,
  libkrb5,
  pulseaudio,
  udev,
  xorg,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dungeondraft";
  version = "1.2.0.1";

  src = requireFile {
    name = "Dungeondraft-${finalAttrs.version}-Linux64.deb";
    url = "https://dungeondraft.net/";
    hash = "sha256-UvvUCQ1RkhwBPMet/zD0JjI7DPbF4ixzOX85Fi3v/BE=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    libGL
    libkrb5
    pulseaudio
    udev
    zlib
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
  ];

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $src .";
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -R usr/share opt $out/

    substituteInPlace $out/share/applications/Dungeondraft.desktop \
      --replace "Exec=/opt/Dungeondraft/Dungeondraft.x86_64" "Exec=Dungeondraft"

    ln -s $out/opt/Dungeondraft/Dungeondraft.x86_64 $out/bin/Dungeondraft
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/Dungeondraft \
      --prefix PATH : ${lib.makeBinPath [
      zenity
      xdg-utils
      xdg-desktop-portal
    ]}
  '';

  meta = {
    homepage = "https://dungeondraft.net/";
    description = "A mapmaking tool for Tabletop Roleplaying Games, designed for battlemap scale";
    license = lib.licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = with lib.maintainers; [jsusk];
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
  };
})
