{ self, inputs, ... }:
{
  flake.nixosModules.WSL = { userconf, ... }: {
    imports = with self.nixosModules; [
      base
      environment
      user
      openssh
      keyring

      javafxlib
      electronDev
      python
      rustWASM

      inputs.nixos-wsl.nixosModules.default
    ];
    wsl = {
      enable = true;
      defaultUser = userconf.username;
      startMenuLaunchers = true;
    };

    home-manager.users.${userconf.username}.imports = with self.homeModules; [
      neovim
      yazi
      claude
      git
      bash
      fastfetch
      node
    ];
  };
}
