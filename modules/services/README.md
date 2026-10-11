# Services

Services config for various purposes.


## [eduroam](./eduroam.nix)

Claude generated secure version of my older configs:

PEAP-MSCHAPv2 profile for NTNU's eduroam, pinned to NTNU Root CA.
Values below come from NTNU's eduroam CAT profile (cat.eduroam.org IdP 74, profile 78): EAP type 25 (PEAP), inner type 26 (MSCHAPv2), outer identity anon@ntnu.no, ServerID radius.ntnu.no and a single self-signed "NTNU Root CA" (valid until 2037-02-16, SHA256 b6:12:4d:8f:f9:1a:83:bd:0d:b5:f5:8a:3c:76:cb:ce:d0:10:7e:6d:0a:76:be:58:12:43:d6:08:ab:aa:f0:88).

The password is never in the store: ensureProfiles runs the generated keyfile through envsubst with /var/lib/secrets/eduroam.env as the systemd EnvironmentFile, and writes the result to /run/NetworkManager/system-connections/eduroam.nmconnection as 0600 root. 
Create the secret with the `mkedupass` alias.

The CA certificate does land in the store as a world readable path. 
That is intended, it is a public certificate and wpa_supplicant must be able to read.
  
## [satisfactory](./satisfactory.nix)

### Satisfactory dedicated server

Runs as a container and opened/closed through an HTTP API.

 #### How it fits together:
1. oci-containers runs the robtme/satisfactory-server image as the systemd unit podman-satisfactory.service. It does NOT start on boot (autoStart = false).
2. webhook (a small Go HTTP server) listens on localhost and runs `systemctl <verb> podman-satisfactory.service` when a request has the right token.
3. A polkit rule lets the unprivileged webhook user start/stop that ONE unit.
4. nginx exposes webhook over HTTPS at https://satisfactory.<topDom>/hooks/<verb>.

 #### Usage:
   curl -X POST -H "Authorization: Bearer $TOKEN" https://satisfactory.<topDom>/hooks/start
   curl -X POST -H "Authorization: Bearer $TOKEN" https://satisfactory.<topDom>/hooks/stop
   curl -X POST -H "Authorization: Bearer $TOKEN" https://satisfactory.<topDom>/hooks/is-active

#### One-time setup on the host:

```bash
echo "SATISFACTORY_API_TOKEN=$(openssl rand -hex 32)" | sudo tee /etc/satisfactory-api.env
sudo chmod 600 /etc/satisfactory-api.env
```

DNS for satisfactory.<topDom> must point at this machine so ACME can issue a cert.

 Debugging:

```bash
journalctl -u podman-satisfactory   game server output (steamcmd update + game log)
journalctl -u webhook               API requests and hook results
```

Game data lives in /var/lib/satisfactory (saves in saved/, backups in backups/).


