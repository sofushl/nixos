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
