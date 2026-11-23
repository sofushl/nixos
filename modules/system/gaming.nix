# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{ inputs, ... }: {
  flake.nixosModules.gaming =
    {
      pkgs,
      userconf,
      ...
    }:

    {
      preservation.preserveAt."/persistent".users.${userconf.username}.directories = [
        ".steam"
        ".local/share/Steam/"

        ".config/heroic"
        ".local/state/Heroic"

        ".local/share/PrismLauncher/"

        ".var"

        "Games"
        ".config/supertuxkart"
      ];

      programs.steam = {
        package = pkgs.steam;
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = false;
        gamescopeSession.enable = true;
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      environment.systemPackages = with pkgs; [
        protonup-qt
        wine
        heroic
        r2modman
        supertuxkart
        prismlauncher
      ];

      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak = {
        enable = true;
        packages = [
          "org.vinegarhq.Sober" # Roblox
        ];
        remotes = [
          {
            name = "flathub";
            location = "https://flathub.org/repo/flathub.flatpakrepo";
          }
        ];
      };
    };
}
