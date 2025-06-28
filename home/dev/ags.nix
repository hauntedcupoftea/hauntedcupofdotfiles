{ inputs, pkgs, ... }: {
  programs.ags = {
    enable = true;
    configDir = ../ags;
    extraPackages = with pkgs; [
      inputs.astal.packages.${pkgs.system}.battery
      fzf
    ];
  };
}
