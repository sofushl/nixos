{
  flake.nixosModules.eduroam =
    { userconf, pkgs, ... }:
    {
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
              ca-cert = "${pkgs.fetchurl {
                url = "https://gist.githubusercontent.com/sofushl/a45bf61f53b133a2d2f9d6b206995379/raw/059595c7847674b9ef2f810416b2548ab4189725/ntnu-root-ca.pem";
                hash = "sha256-0uuK05B0jCO+uAQ+yN89tcdGyIAgJBURPYQ9ji+jenM=";
              }}";
            };
          };
        };
      };
    };
}
