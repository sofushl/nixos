# Home manager configuration

Home manager based program configurations.


#### [rclone](./rclone.nix)

After building with rclone in the config and .config/rclone/nextcloud.pass preserved you run:

```bash
rclone obscure 'APP_PASSWORD' > ~/.config/rclone/nextcloud.pass
```

APP_PASSWORD being the app password you generated on your nextcloud server.


First bisync run must be done manually to establish the baseline:

```bash
rclone bisync nextcloud: ~/Cloud --resync --verbose 
# Rerun until it passes without network related failures
```


After restarting the rclone service you should now be bisyncing to ~/Cloud


#### [vscodium](./vscodium.nix)

Recreation of my vscode config using home-manager module vscodium.

Explaination of UI patch from claude:
mplab-ui saves connected-kit data with `path.join(__dirname, "data")`, i.e. inside its own extension directory, and the pinout explorer reads it back from there. Under the store that directory is read-only, so the write fails and the webview reports it as a "platform connection issue" instead. 
Redirect the writes into ~/.mplab, which is already preserved (with my config).
fs-extra's ensureFile creates the parent directory, so nothing else is needed. 
--replace-fail so an extension update that renames the minified variable breaks the build instead of silently losing the pinouts again.


#### [ciscovpn](./ciscovpn.nix)

nixosModule for the [cisco-secure-client](../../pkgs/README.md#cisco-secure-client)
package. The package itself is pure; this module owns everything that has to
exist outside the nix store.

**The /opt prefix.** The blobs resolve `cfom.so`, `bin/vpnui` and `resources/`
through absolute `/opt/cisco/secureclient` paths, so that tree has to exist.
The prefix itself must stay writable — `vpnagentd` mktemps `pem.XXXXXX`
directly in it, and the profile and script directories are read-write — so
only the immutable parts (`bin`, `lib`, `resources`, the manifest and the two
`.xsd` files) are symlinked into the store with tmpfiles `L+`, while
`vpn/profile` and `vpn/script` are created as real directories.

**tun.** `vpnagentd` needs `/dev/net/tun`. The shipped `load_tun.sh` shells out
to `/sbin/lsmod` and `/sbin/modprobe`, which do not exist here, so it is left
out of the unit and the module sets `boot.kernelModules = [ "tun" ]` instead.

**/bin/systemctl.** `vpnagentd` hardcodes `/bin/systemctl restart
systemd-resolved` when it restores DNS after a disconnect, so there is a
tmpfiles symlink for it. Drop that line if you would rather not populate
`/bin`.

**nix-ld.** `programs.nix-ld.libraries` is a global surface: every nix-ld
consumer on the host gets these libraries in `NIX_LD_LIBRARY_PATH`, including
the MPLAB backends. Usually harmless, but `libxml2_13` in particular is an
older ABI than the rest of the system, so this is the line to suspect if
something unrelated starts misbehaving.

**Autostart.** `vpnagentd` logs `LOGINUTILS_ERROR_DESKTOP_FILE_NOT_FOUND`
because it wants to write an autostart entry to
`/usr/share/applications`. Harmless. To start the tray UI with the session the
NixOS-native way, add to the home-manager side:

```nix
systemd.user.services.vpnui = {
  Unit.Description = "Cisco Secure Client UI";
  Unit.PartOf = [ "graphical-session.target" ];
  Install.WantedBy = [ "graphical-session.target" ];
  Service.ExecStart = "${pkgs.callPackage ../../pkgs/cisco-secure-client.nix { }}/bin/vpnui";
};
```

**DNS rough edge.** `vpnagentd` renames `/etc/resolv.conf` to
`/etc/resolv.conf.vpnbackup` and writes its own. With `systemd-resolved` that
means replacing the stub symlink with a regular file. It restores it on
disconnect, but NetworkManager or a rebuild in between will fight over it —
worth an `ls -l /etc/resolv.conf` before and after a connect/disconnect cycle.

**Debugging.** Everything logs to the journal under `csc_vpnagent`, `csc_ui`
and `csc_webhelper`:

```bash
journalctl -f | grep -iE "csc_|webViewLoadFailed"
```
