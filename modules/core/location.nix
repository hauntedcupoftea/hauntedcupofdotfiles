{ pkgs, ... }: {
  services.geoclue2 = {
    enable = true;
  };

  location.provider = "geoclue2";

  environment.systemPackages = [
    pkgs.gnome-maps
  ];
}
