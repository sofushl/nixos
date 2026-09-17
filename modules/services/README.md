# Services

Services config for various purposes.


#### [eduroam](./eduroam.nix)

Claude generated secure version of my older configs:

PEAP-MSCHAPv2 profile for NTNU's eduroam, pinned to NTNU Root CA.
Values below come from NTNU's eduroam CAT profile (cat.eduroam.org IdP 74, profile 78): EAP type 25 (PEAP), inner type 26 (MSCHAPv2), outer identity anon@ntnu.no, ServerID radius.ntnu.no and a single self-signed "NTNU Root CA" (valid until 2037-02-16, SHA256 b6:12:4d:8f:f9:1a:83:bd:0d:b5:f5:8a:3c:76:cb:ce:d0:10:7e:6d:0a:76:be:58:12:43:d6:08:ab:aa:f0:88).

The password is never in the store: ensureProfiles runs the generated keyfile through envsubst with /var/lib/secrets/eduroam.env as the systemd EnvironmentFile, and writes the result to /run/NetworkManager/system-connections/eduroam.nmconnection as 0600 root. 
Create the secret with the `mkedupass` alias.

The CA certificate does land in the store as a world readable path. 
That is intended, it is a public certificate and wpa_supplicant must be able to read.
  

