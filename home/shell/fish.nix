{ ... }: {
  programs.fish = {
    enable = true;
    loginShellInit = "";
    interactiveShellInit = ''
      set fish_greeting # disable greeting
      starship init fish | source
    '';
    shellAliases = {
      ll = "ls -la";
      update = "sudo nixos-rebuild switch";
      nix-gc = "sudo nix-collect-garbage -d";
    };
    functions = {
      y = ''
        	set tmp (mktemp -t "yazi-cwd.XXXXXX")
         	yazi $argv --cwd-file="$tmp"
         	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
         		builtin cd -- "$cwd"
         	end
         	rm -f -- "$tmp"
      '';
    };
  };

  # catppuccin.fish.enable = true;

  # this is potentially dangerous (enable after ags i think)
  # home.sessionVariables = {
  #   SHELL = "${pkgs.fish}/bin/fish";
  # };
}
