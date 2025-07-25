{ pkgs
, ...
}: {
  programs.fish.enable = true;
  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
  ];
  # the fix to make fish work without cursor sizing issue
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
