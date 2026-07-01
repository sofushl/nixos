{
  self,
  inputs,
  lib,
  ...
}:
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
      niri
      workMonitors

      {
        home.shellAliases =
          let
            launcher = "/home/soli/Workspace/launcher/";
            shared = "/home/soli/Workspace/shared/";
            nrfapps = "/home/soli/.nrfconnect-apps/local/";
          in
          {
            "launch" = ''
              sudo chown root:root /home/soli/Workspace/launcher/node_modules/electron/dist/chrome-sandbox
              sudo chmod 4755 /home/soli/Workspace/launcher/node_modules/electron/dist/chrome-sandbox
              ${launcher}node_modules/electron/dist/electron  ${launcher} --ozone-platform=wayland --enable-features=UseOzonePlatform
            '';

            "pack" = ''
              npm pack --prefix ${shared}
              npm i --save-dev ${shared}nordicsemiconductor-pc-nrfconnect-shared-252.0.0.tgz
            '';

          };

        programs.npm.package = lib.mkForce pkgs.nodejs_22;
      }
    ];
  };
}
