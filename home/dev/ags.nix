{ pkgs, ... }: {
  programs.ags = {
    enable = true;
    configDir = ~/code/ags-bar; # THIS PATH WILL BE DIFFERENT FOR YOU
    extraPackages = with pkgs; [
      inputs.astal.packages.${pkgs.system}.battery
      fzf
    ];
  };
}
