{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles.default.extensions.force = true;
  };

  home.packages = with pkgs; [
    geckodriver # Selenium-like browser automation for Firefox
  ];
}
