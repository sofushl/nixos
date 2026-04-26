{
  description = "Portable NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    omarchy-nix = {
      url = "github:sofuslind/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      omarchy-nix,
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
            home-manager.useUserPackages = false;

            home-manager.users.${userconf.username} = {
              imports =
                (if userconf.devenv then [ /home/${userconf.username}/Documents/nixos/neovim.nix ] else [ ])
                ++ (if userconf.niri then [ /home/${userconf.username}/Documents/nixos/niri/home.nix ] else [ ]);

              home.stateVersion = "26.05";
            };
          }
        ]
        ++ (
          if userconf.omarchy then
            [

              omarchy-nix.nixosModules.default

              home-manager.nixosModules.home-manager
              {

                # Configure omarchy
                omarchy = {
                  username = userconf.username;
                  full_name = userconf.displayname;
                  email_address = userconf.email;
                  theme = "tokyo-night";
                };

                home-manager.users.${userconf.username}.imports = [ omarchy-nix.homeManagerModules.default ];
              }

            ]
          else
            [ ]
        );
      };
    };
}
