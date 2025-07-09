{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, gtk4
, gtk4-layer-shell
, xdg-desktop-portal-hyprland
, hyprland
, rust-bin
}:

rustPlatform.buildRustPackage {
  pname = "hyprland-preview-share-picker";
  version = "0.unstable-2024-05-20";

  src = fetchFromGitHub {
    owner = "WhySoBad";
    repo = "hyprland-preview-share-picker";
    # replace with latest commit hash
    rev = "211b7890ed3332f4d1bb1f1a96999e18874a9c3c";
    # Replace with the correct hash.
    # You can get this by running `nix build .#hyprland-preview-share-picker`
    hash = "sha256-Zztb0soSN/NynWnBIGPuUNRKt2xSx/+f+QpYIPRyRdc=";
    fetchSubmodules = true;
  };

  # Replace with the correct cargoHash.
  # Nix will tell you the correct hash after the `src` hash is correct.
  cargoHash = "sha256-AqX9jKj7JLEx1SLefyaWYGbRdk0c3H/NDTIsZy6B6hY=";

  nativeBuildInputs = [
    pkg-config
    # Use nightly toolchain from rust-overlay
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
      extensions = [ "rust-src" ];
    }))
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
    xdg-desktop-portal-hyprland
    hyprland
  ];


  meta = with lib; {
    description = "An alternative share picker for hyprland with window and monitor previews";
    homepage = "https://github.com/WhySoBad/hyprland-preview-share-picker";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
