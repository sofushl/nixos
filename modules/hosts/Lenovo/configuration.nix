{ self, inputs, ... }:

{
  flake.nixosModules.LenovoConfiguration = {
    imports = with self.nixosModules; [
      LenovoHardware

      homeserverPreset
    ];

    networking.hostName = "Lenovo";
  };
}
