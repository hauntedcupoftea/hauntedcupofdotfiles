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
    # TODO: Replace with the correct hash.
    # You can get this by running `nix build .#nixosConfigurations.ge66-raider.config.system.build.toplevel`
    # or by building the specific package once with a fake hash like `lib.fakeHash`.
    hash = "sha256-R1T3n7Pj56rD844Y39yRk/xJ2i/Y/lU5uYc9KxK1dGk=";
    fetchSubmodules = true;
  };

  # TODO: Replace with the correct cargoHash.
  # Nix will tell you the correct hash after the `src` hash is correct.
  cargoHash = "sha256-sC/QvH7c4G1z18iW/kUe/sYg5/k0Y5YvD5nI10YQe1E=";

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

  postBuild = ''
    ./target/release/hyprland-preview-share-picker schema > schema.json
  '';

  postInstall = ''
    install -Dm0644 schema.json $out/share/hyprland-preview-share-picker/schema.json
  '';

  meta = with lib; {
    description = "An alternative share picker for hyprland with window and monitor previews";
    homepage = "https://github.com/WhySoBad/hyprland-preview-share-picker";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
