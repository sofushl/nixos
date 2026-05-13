{ self, inputs, ... }:

{
  flake.nixosModules.AcerConfiguration = {
    imports = with self.nixosModules; [
      AcerHardware

      niriPreset

    ];
    networking.hostName = "Acer";
  };
}
