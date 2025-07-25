{ inputs, pkgs, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ];
  stylix = {
    enable = true;
    image = ../../wallpapers/malenia.jpg;
    polarity = "dark";
    fonts = {
      sansSerif = {
        package = pkgs.nerd-fonts.fira-code;
        name = "Fira Code Nerd Font";
      };
      monospace = {
        package = pkgs.nerd.fonts.fira-code;
        name = "Fira Code Nerd Font Mono";
      };
    };
  };
}
