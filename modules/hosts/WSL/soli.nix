{ self, inputs, ... }:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  homeconf = import ../../../lib/soli.nix;
  sshkeys = import ../../../lib/sshkeys.nix;
in
{
  flake.homeConfigurations.soli = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inherit inputs;
      userconf = homeconf // sshkeys;
    };

    modules = with self.homeModules; [
      dev
      yazi
      fastfetch
      git
      user
      neovim
      bash
      firefox
      wezterm
    ];
  };
}
