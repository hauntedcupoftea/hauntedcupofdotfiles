{ inputs, pkgs, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ];
  stylix = {
    enable = true;
    image = ../../wallpapers/malenia.jpg;
    polarity = "dark";
    cursor = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 40;
    };
    fonts = {
      sansSerif = {
        package = pkgs.nerd-fonts.fira-code;
        name = "Fira Code Nerd Font";
      };
      monospace = {
        package = pkgs.nerd.fonts.fira-code;
        name = "Fira Code Nerd Font Mono";
      };
      sizes = {
        popups = 12;
        applications = 13;
        terminal = 13;
        desktop = 14;
      };
    };
  };
}
