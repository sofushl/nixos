{ self, inputs, ... }:

{
  flake.nixosModules.networkmanager =
    { userconf, lib, ... }:
    {

      networking.networkmanager = {
        enable = true;

        ensureProfiles.profiles = {
          eduroam = {
            connection = {
              id = "eduroam";
              type = "wifi";
            };

            wifi = {
              mode = "infrastructure";
              ssid = "eduroam";
            };

            wifi-security = {
              "key-mgmt" = "wpa-eap";
            };

            "802-1x" = {
              eap = "peap";
              identity = "${userconf.username}@ntnu.no";
              password = userconf.edupass;
              "phase2-auth" = "mschapv2";
            };
          };
        }
        // lib.mapAttrs (ssid: password: {
          connection = {
            id = ssid;
            type = "wifi";
          };

          wifi = {
            mode = "infrastructure";
            inherit ssid;
          };

          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = password;
          };
        }) userconf.networks;
      };
    };
}
