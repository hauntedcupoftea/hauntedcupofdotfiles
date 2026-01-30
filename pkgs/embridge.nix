{
  lib,
  buildFHSEnv,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  rpmextract,
  openssl,
  zlib,
  icu,
  bash,
  coreutils,
  writeShellScript,
}: let
  embridgeUnwrapped = stdenv.mkDerivation rec {
    pname = "embridge-unwrapped";
    version = "3.3.0.2";

    src = fetchzip {
      url = "https://resources.emudhra.com/hs/RedHat/latest/emBridge.zip";
      sha256 = "sha256-ZJHlFH/4pFaEE81772+KrlNZlfFZV4wIWffmxtaHAD8=";
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

    autoPatchelfIgnoreMissingDeps = ["liblttng-ust.so.0"];

    unpackPhase = ''
      mkdir -p $TMPDIR/rpm-extract
      cd $TMPDIR/rpm-extract
      rpmextract $src/emBridge/emBridge-${version}.rpm
    '';

    installPhase = ''
      mkdir -p $out/opt/eMudhra
      cp -r opt/eMudhra/emBridge-${version} $out/opt/eMudhra/
    '';

    meta = with lib; {
      description = "eMudhra eMbridge service (unwrapped)";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };

  startScript = writeShellScript "embridge-start" ''
    # Use /var/lib/embridge if running as service, otherwise use temp
    if [ -d /var/lib/embridge ] && [ -w /var/lib/embridge ]; then
      WORK_DIR="/var/lib/embridge"
    else
      WORK_DIR="''${XDG_RUNTIME_DIR:-/tmp}/embridge-$$"
      mkdir -p "$WORK_DIR"
      cp -r ${embridgeUnwrapped}/opt/eMudhra/emBridge-3.3.0.2/* "$WORK_DIR/"
      chmod -R u+w "$WORK_DIR"
      trap "rm -rf '$WORK_DIR'" EXIT
    fi

    cd "$WORK_DIR"
    exec ./emBridge "$@"
  '';
in
  buildFHSEnv {
    name = "embridge";

    targetPkgs = pkgs: [
      embridgeUnwrapped
      openssl
      zlib
      icu
      bash
      coreutils
      stdenv.cc.cc.lib
    ];

    runScript = startScript;

    passthru = {
      unwrapped = embridgeUnwrapped;
    };

    meta = with lib; {
      description = "eMudhra eMbridge service for crypto token access";
      homepage = "https://embridge.emudhra.com/";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = [];
      # This is a repackaged version of proprietary eMudhra software
      # for compatibility with NixOS. All rights belong to eMudhra.
    };
  }
