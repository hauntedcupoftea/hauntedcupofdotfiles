{ inputs, pkgs, ... }: {
  environment.systemPackages = [
    inputs.quickshell.packages.${pkgs.system}.default
    pkgs.kdePackages.qtdeclarative
  ];

}
 
