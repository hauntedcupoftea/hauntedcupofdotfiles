{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  rpmextract,
  openssl,
  zlib,
  icu,
}:
stdenv.mkDerivation rec {
  pname = "embridge";
  version = "3.3.0.2";

  src = fetchzip {
    url = "https://resources.emudhra.com/hs/RedHat/latest/emBridge.zip";
    sha256 = lib.fakeSha256; # Replace with actual hash after first build attempt
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    rpmextract
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    openssl
    zlib
    icu
  ];

  unpackPhase = ''
    cp -r $src ./source
    cd source
    rpmextract *.rpm
  '';

  installPhase = ''
    mkdir -p $out/opt/eMudhra
    cp -r opt/eMudhra/emBridge-${version} $out/opt/eMudhra/

    # Create a wrapper script
    mkdir -p $out/bin
    cat > $out/bin/embridge <<EOF
    #!/bin/sh
    cd $out/opt/eMudhra/emBridge-${version}
    exec ./emBridge "\$@"
    EOF
    chmod +x $out/bin/embridge
  '';

  meta = with lib; {
    description = "eMudhra eMbridge service for crypto token access";
    homepage = "https://embridge.emudhra.com/";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
