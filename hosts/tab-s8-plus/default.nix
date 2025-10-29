{pkgs, ...}: {
  environment.packages = with pkgs; [
    gh
    git
    fastfetchMinimal
    hostname
    curl
    openssh

    # Some common stuff that people expect to have
    #procps
    #killall
    #diffutils
    #findutils
    #utillinux
    #tzdata
    #man
    #gnugrep
    #gnupg
    #gnused
    #gnutar
    #bzip2
    #gzip
    #xz
    #zip
    #unzip
  ];

  # NOT possible right now on nix-on-droid
  # networking.hostName = "tab-s8-plus";

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  terminal.font = "${pkgs.nerd-fonts.fira-code}/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFont-Regular.ttf";
  # Locale because nix-on-droid hates me
  time.timeZone = "Asia/Kolkata";

  user = {
    # apparently this is read-only?
    # userName = "tea";
    shell = "${pkgs.fish}/bin/fish";
  };

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Configure home-manager
  home-manager = {
    config = ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
  };
}
