{
  inputs,
  config,
  ...
}: {
  imports = [
    ./tea.nix
    ./packet.nix
    inputs.hjem.nixosModules.default
  ];

  hjem = {
    extraModules = [
      inputs.hjem-rum.hjemModules.default
      ../hjem
    ];
    specialArgs = {
      inputs = inputs;
      nixosConfig = {
        dotfiles = {
          desktop = {
            enable = config.dotfiles.desktop.enable;
            monitors = config.dotfiles.desktop.monitors;
            audio.enable = config.dotfiles.desktop.audio.enable;
          };
          services = {
            enable = config.dotfiles.services.enable;
            podman.enable = config.dotfiles.services.podman.enable;
          };
        };
      };
    };
    clobberByDefault = true;
  };
}
