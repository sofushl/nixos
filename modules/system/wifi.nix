# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.nixosModules.wifi =
    { userconf, pkgs, ... }:
    {
      programs.captive-browser = {
        enable = true;
        interface = userconf.wifiboard;
      };

      networking.networkmanager = {
        enable = true;

        ensureProfiles = {
          environmentFiles = [ "/var/lib/secrets/eduroam.env" ];

          profiles.eduroam = {
            connection = {
              id = "eduroam";
              type = "wifi";
              permissions = "";
            };

            wifi = {
              mode = "infrastructure";
              ssid = "eduroam";
            };

            wifi-security."key-mgmt" = "wpa-eap";

            "802-1x" = {
              eap = "peap;";
              identity = "${userconf.username}@ntnu.no";
              "anonymous-identity" = "anon@ntnu.no";
              password = "$EDUROAM_PASSWORD";
              "phase2-auth" = "mschapv2";
              "domain-suffix-match" = "radius.ntnu.no";
              ca-cert = "${(import ../../lib/pkgs.nix pkgs).ntnuRootCa}";
            };
          };
        };
      };
    };
}
