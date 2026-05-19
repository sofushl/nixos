{
  self,
  inputs,
  userconf,
  ...
}:

{
  flake.nixosModules.eduroam = {
    environment.etc."NetworkManager/system-connections/eduroam.nmconnection" = {
      text = ''
        [connection]
        id=eduroam
        type=wifi
        interface-name=${userconf.wifiboard}

        [wifi]
        mode=infrastructure
        ssid=eduroam

        [wifi-security]
        key-mgmt=wpa-eap

        [802-1x]
        eap=peap
        password=${userconf.password}
        identity=${userconf.username}@ntnu.no
        phase2-auth=mschapv2

        [ipv4]
        method=auto

        [ipv6]
        method=auto
      '';
      mode = "0600";
    };
  };
}
