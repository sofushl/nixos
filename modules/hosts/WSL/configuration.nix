{ self, inputs, ... }:

{
  flake.nixosModules.WSLConfiguration =

    { userconf, lib, ... }:

    {
      imports = with self.nixosModules; [
        base
        user
        develop

        inputs.nixos-wsl.nixosModules.default
      ];

      home-manager.users.${userconf.username}.imports = [
        ../../../home/dev.nix
        ../../../home/git.nix
        ../../../home/yazi.nix
        ../../../home/neovim.nix
        ../../../home/fastfetch.nix
      ];

      networking.hostName = "WSL";
      networking.resolvconf.enable = lib.mkForce false;

      wsl = {
        enable = true;
        defaultUser = userconf.username;
        startMenuLaunchers = true;
      };

      system.stateVersion = userconf.state;
    };
}
