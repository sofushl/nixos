{ self, inputs, ... }:

{
  flake.nixosConfigurations.WSL = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs;
      userconf = default // wslconf;
    };

    modules = [
      ./configuration.nix
    ]
    ++ defaultModules;
  };
}
