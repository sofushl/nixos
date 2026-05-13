{ selv, inputs, ... }:

{
  flake.nixosConfigurations.Acer = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = default // acerconf;
    };

    modules =
      with self.nixosModules;
      [
        AcerConfiguration
      ]
      ++ defaultModules;
  };

}
