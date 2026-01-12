{pkgs, ...}: {
  imports = [
    ./discord.nix
    ./gaming.nix
    ./minecraft.nix
    ./satisfactory.nix
  ];

  home.packages = with pkgs; [lact];
}
