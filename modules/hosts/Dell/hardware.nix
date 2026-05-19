{ self, inputs, ... }:

{
  flake.nixosModules.DellHardware =
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
