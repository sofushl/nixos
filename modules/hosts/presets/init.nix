{ self, ... }:

{
  flake.nixosModules.initPreset =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        disko
        preservation
      ];
    };
}
