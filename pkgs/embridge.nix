{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  rpmextract,
  openssl,
  zlib,
  icu,
  lttng-ust,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "embridge";
  version = "3.3.0.2";
  src = fetchzip {
    url = "https://resources.emudhra.com/hs/RedHat/latest/emBridge.zip";
    sha256 = "sha256-ZJHlFH/4pFaEE81772+KrlNZlfFZV4wIWffmxtaHAD8=";
    stripRoot = false;
  };
  nativeBuildInputs = [
    autoPatchelfHook
    rpmextract
    makeWrapper
  ];
  buildInputs = [
    stdenv.cc.cc.lib
    openssl
    zlib
    icu
  ];

  # Ignore missing liblttng-ust.so.0 - it's only for tracing
  autoPatchelfIgnoreMissingDeps = ["liblttng-ust.so.0"];

  unpackPhase = ''
    mkdir -p $TMPDIR/rpm-extract
    cd $TMPDIR/rpm-extract
    rpmextract $src/emBridge/emBridge-${version}.rpm
  '';

  installPhase = ''
    mkdir -p $out/opt/eMudhra
    cp -r opt/eMudhra/emBridge-${version} $out/opt/eMudhra/

    # Install systemd service
    mkdir -p $out/lib/systemd/system
    cp opt/eMudhra/emBridge-${version}/emBridge.service $out/lib/systemd/system/

    # Patch service file to use nix store path
    substituteInPlace $out/lib/systemd/system/emBridge.service \
      --replace "/opt/eMudhra/emBridge-${version}" "$out/opt/eMudhra/emBridge-${version}"

    # Create wrapper script
    mkdir -p $out/bin
    makeWrapper $out/opt/eMudhra/emBridge-${version}/emBridge $out/bin/embridge \
      --chdir $out/opt/eMudhra/emBridge-${version}
  '';

  meta = with lib; {
    description = "eMudhra eMbridge service for crypto token access";
    homepage = "https://embridge.emudhra.com/";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
