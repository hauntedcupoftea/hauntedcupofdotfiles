{pkgs, ...}: {
  location.provider = "geoclue2";
  environment.systemPackages = [
    pkgs.gnome-maps
  ];
}
