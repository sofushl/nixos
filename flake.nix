{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    #import-tree = {
    #  url = "github:vic/import-tree";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #stylix = {
    #  url = "github:nix-community/stylix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #impermanence = {
    #  url = "github:nix-community/impermanence";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs =
    inputs@{ ... }:
    let
      userconf = import ./lib/sofushl.nix;
      lenovoconf = import ./hosts/Lenovo/lib.nix;
      acerconf = import ./hosts/Acer/lib.nix;
      wslconf = import ./hosts/WSL/lib.nix;
      sshkeys = import ./lib/sshkeys.nix;
      secrets = import /etc/nixos/secrets.nix;
      default = userconf // sshkeys // secrets;

      defaultModules = [

        inputs.home-manager.nixosModules.home-manager
        { home-manager.useGlobalPkgs = true; }
      ];
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ "x86_64-linux" ];

      flake.nixosConfigurations = {

        Acer = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
            userconf = default // acerconf;
          };

          modules = [
            ./hosts/Acer
          ]
          ++ defaultModules;
        };

        Lenovo = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
            userconf = default // lenovoconf;
          };

          modules = [
            ./hosts/Lenovo
          ]
          ++ defaultModules;
        };

        WSL = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
            userconf = default // wslconf;
          };

          modules = [
            ./hosts/WSL
          ]
          ++ defaultModules;
        };
      };
    };
}
