{
  description = "Portable NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";

      userconf = import "/etc/nixos/variables.nix";
    in
    {
      nixosConfigurations.${userconf.hostname} = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit userconf;
        };

        modules = [
          /etc/nixos/hardware-configuration.nix
          ./main.nix

          home-manager.nixosModules.home-manager
          {

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${userconf.username} = {
              imports = [
                /home/${userconf.username}/Documents/nixos/development/neovim.nix
              ]
              ++ (
                if userconf.niri then
                  [
                    /home/${userconf.username}/Documents/nixos/niri/home.nix
                  ]
                else
                  [ ]
              );

              home.stateVersion = "26.05";
            };
          }
        ];
      };
    };
}
