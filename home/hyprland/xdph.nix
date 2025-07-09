{ pkgs, config, ... }: {

  home.file = {
    "${config.xdg.configHome}/hypr/xdph.conf" = {
      text = ''
        screencopy {
          allow_token_by_default=true
          custom_picker_binary=${pkgs.hyprland-preview-share-picker}/bin/hyprland-preview-share-picker
        }
      '';
    };
  };
}
