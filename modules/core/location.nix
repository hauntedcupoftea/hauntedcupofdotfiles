{ pkgs, ... }: {
  services.gpsd = {
    enable = true;
  };
  environment.systemPackages = [
    pkgs.gnome-maps
  ];
}
