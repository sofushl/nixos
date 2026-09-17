{
  flake.nixosModules.eduroam =
    { userconf, ... }:
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
              "ca-cert" = "${../../dotfiles/ntnu-root-ca.pem}";
              "domain-suffix-match" = "radius.ntnu.no";
            };
          };
        };
      };
    };
}
