{ self, inputs, ... }:

{
  flake.nixosModules.AcerHardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:

    {
      networking.hostName = "Dell";
    };
}
