{ pkgs, ... }: {
  hardware.openrazer = {
    enable = true;
    users = [ "tea" ]; # REPLACE WITH USERNAME
  };
  environment.systemPackages = with pkgs; [
    openrazer-daemon
    polychromatic
  ];
}
