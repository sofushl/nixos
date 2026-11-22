# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ self, ... }:
{
  flake.homeModules.work = { lib, pkgs, ... }: {
    home.packages = with pkgs; [
      postman
      spotify
      vlc
      loupe
    ];

    imports = with self.homeModules; [
      base
      environment
      user
      niri
      mimeapps

      bash
      fastfetch
      kitty
      browser
      neovim
      yazi
      git
      claude
      opencode
      bitwarden

    ];

    programs.hyprlock.package = lib.mkForce null;
    wayland.windowManager.niri.settings.spawn-at-startup = lib.mkForce [ ];

    wayland.windowManager.niri.settings._children = lib.mkForce [
      {
        output = {
          _args = [ "eDP-1" ];
          position._props = {
            x = 0;
            y = 0;
          };
          scale = 1.25;
        };
      }
      {
        output = {
          _args = [ "DP-2" ];
          scale = 1.2;
        };
      }
      {
        output = {
          _args = [ "HDMI-A-1" ];
          scale = 2;
        };
      }
      {
        output = {
          _args = [ "DP-8" ];
          position._props = {
            x = 1536;
            y = 0;
          };
        };
      }
      {
        output = {
          _args = [ "DP-9" ];
          position._props = {
            x = 3456;
            y = 0;
          };
        };
      }
    ];

    programs.npm = {
      enable = true;
      package = pkgs.nodejs_22;
      settings = {
        prefix = "\${HOME}/.npm";
        color = true;
        update-notifier = false;
        fund = false;
      };
    };

    home.shellAliases =
      let
        dir = "/home/soli/OneDrive/Development/";
      in
      {
        "launch" = ''
          sudo chown root ${dir}launcher/node_modules/electron/dist/chrome-sandbox
          sudo chmod 4755 ${dir}launcher/node_modules/electron/dist/chrome-sandbox
          npm --prefix ${dir}launcher run app
        '';

        "pack" = ''
          tarball=$(cd ${dir}shared && npm pack --pack-destination ${dir}shared --ignore-scripts | grep -E '\.tgz$')
          npm i --save-dev "${dir}shared/$tarball"
          npm run build:dev
        '';
      };
  };
}
