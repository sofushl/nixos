{ self, inputs, ... }:

{
  flake.nixosModules.networkmanager =
    { userconf, lib, ... }:
    {
      networking.networkmanager = {
        enable = true;

        ensureProfiles.profiles.eduroam = {
          connection = {
            id = "eduroam";
            type = "wifi";
            interface-name = userconf.wifiboard;
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
            password = userconf.password;
            "phase2-auth" = "mschapv2";
          };
        };
      };
    };
}
