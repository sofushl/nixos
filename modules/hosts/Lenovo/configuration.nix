{ selv, inputs, ... }:

{
  flake.nixosModules.LenovoConfiguration = {
    imports = [
      LenovoHardware

      homeserverPreset
    ];

    networking.hostName = "Lenovo";
  };
}
