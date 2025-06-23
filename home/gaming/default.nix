{ pkgs, ... }: {
  imports = [
    ./discord.nix
    ./gaming.nix
    ./minecraft.nix
  ];

  # MISC packages
  home.packages = with pkgs; [
    samrewritten # steam achievements manager
  ];
}
