{lib, ...}: {
  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface" = {
          cursor-theme = "Bibata-Modern-Classic";
          cursor-size = lib.gvariant.mkInt32 28;
        };
      };
    }
  ];
}
