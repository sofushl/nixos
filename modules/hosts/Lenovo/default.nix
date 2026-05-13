{ self, inputs, ... }:

{
  flake.nixosConfigurations.Lenovo = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = default // lenovoconf;
    };

    modules =
      with self.nixosModules;
      [
        LenovoConfiguration
      ]
      ++ defaultModules;
  };

}
