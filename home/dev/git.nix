{ pkgs, ... }: {
  home.packages = with pkgs; [ gitui ];

  programs.gitui = {
    enable = true;
  };

  # catppuccin.gitui = {
  #   enable = true;
  #   flavor = "mocha";
  # };
}
