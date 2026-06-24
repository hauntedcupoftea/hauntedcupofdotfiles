{lib, ...}: {
  options.dotfiles.services = {
    enable = lib.mkEnableOption "services profile";
  };
}
