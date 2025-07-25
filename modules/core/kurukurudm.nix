{ pkgs
, inputs
, ...
}: {
  imports = [ (inputs.kurukurubar + "/nixosModules/exported/kurukuruDM.nix") ];

  programs.kurukuruDM.package =
    let
      gpurecording = pkgs.callPackage (inputs.kurukurubar + "/pkgs/scripts/gpurecording.nix") { };
      librebarcode = pkgs.callPackage (inputs.kurukurubar + "/pkgs/librebarcode.nix") { };
    in
    pkgs.callPackage (inputs.kurukurubar + "/pkgs/kurukurubar.nix") {
      quickshell = inputs.quickshell.packages.${pkgs.system}.default;
      inherit gpurecording librebarcode;
    };

  programs.kurukuruDM = {
    enable = true;
    settings = {
      wallpaper = ../../wallpapers/malenia.jpg;
      instantAuth = false;
      extraConfig = ''
        monitor = DP-2, preferred, auto, 1
      '';
    };
  };
}
