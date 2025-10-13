{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  # home.file = {
  #   "${config.xdg.configHome}/hypr/xdph.conf" = {
  #     text = ''
  #       screencopy {
  #         allow_token_by_default=false
  #         custom_picker_binary=${config.xdg.configHome}/hypr/pickerscript
  #       }
  #     '';
  #   };
  #   "${config.xdg.configHome}/hypr/pickerscript" = {
  #     text = ''
  #       walker -n --modules xdphpicker
  #     '';
  #     executable = true;
  #   };
  # };

  programs.walker = {
    enable = true;
    runAsService = false;
    package = pkgs.walker;

    # This is Walker's main configuration
    config = {
      app_launch_prefix = "uwsm app -- ";
      ui.fullscreen = true;
      list = {
        height = 200;
      };
      websearch.prefix = "?";
      switcher.prefix = "/";
      general.runner_mode = "drun";
    };
  };
}
