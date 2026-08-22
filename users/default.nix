{inputs, ...}: {
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
    };
    clobberByDefault = true;
  };
}
