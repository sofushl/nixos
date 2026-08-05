# Home manager configuration

Home manager based program configurations.


#### [rclone](./rclone.nix)

After building with rclone in the config and .config/rclone/nextcloud.pass preserved you run:

```bash
rclone obscure 'APP_PASSWORD' > ~/.config/rclone/nextcloud.pass
```

with APP_PASSWORD being the app password you generated on your nextcloud server.

after rebuilding and restarting the rclone service your mount should now be on ~/Cloud


