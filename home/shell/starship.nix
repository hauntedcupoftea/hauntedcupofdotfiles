{...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[](bold blue)"; # Cute arrow symbol for success
        error_symbol = "[✗](bold red)"; # Cross symbol for errors
        vicmd_symbol = "[](bold green)"; # Vim command mode symbol
      };
      nix_shell = {
        symbol = "󱄅";
        impure_msg = "";
        pure_msg = "";
        format = "via [$symbol$state( \($name\))]($style) ";
      };
      # jobs = {

      # };
    };
  };
}
