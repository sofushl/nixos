{ self, ... }:

{
  flake.nixosModules.default =
    { userconf, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        disko
        preservation
        develop
        openssh
      ];
    };
}
