# Packages

Own package definitions for software that is not in nixpkgs, called with
`pkgs.callPackage` from the module that needs it.

The flake never declares flake-parts' `systems`, so there is no `packages`
flake output and `nix build .#something` will not find these. To build one
while iterating:

```bash
nix build --impure --expr \
  '(builtins.getFlake "/home/sofushl/nixos").nixosConfigurations.Elitebook.pkgs.callPackage /home/sofushl/nixos/pkgs/cisco-secure-client.nix {}'
```

#### [cisco-secure-client](./cisco-secure-client.nix)

Cisco Secure Client (formerly AnyConnect) 5.1.12.146, needed for `vpn.ntnu.no`.
There is no nixpkgs package: the packaging request
([#265443](https://github.com/NixOS/nixpkgs/issues/265443)) was closed as not
planned and the attempt in [#306647](https://github.com/NixOS/nixpkgs/pull/306647)
went stale. Paired with the [ciscovpn](../modules/programs/README.md#ciscovpn)
nixosModule, which owns everything outside the store.

**Getting the source.** Cisco does not allow redistribution and the installer
sits behind a Cisco account or your institution's VPN portal, so `src` is a
`requireFile`. Download the Linux *Core & AnyConnect VPN* webdeploy installer
and add it to the store by hand:

```bash
nix-store --add-fixed sha256 cisco-secure-client-linux64-5.1.12.146-core-vpn-webdeploy-k9.sh
```

**Unpacking.** The installer is a shell script with a gzip payload appended
between `--BEGIN ARCHIVE--` and `--END ARCHIVE--` line markers, which is what
the `sed`-free `grep -an` / `head` / `tail` dance in `unpackPhase` carves out.

**Why nix-ld and not autoPatchelfHook.** Cisco ships signed, prebuilt blobs and
`vpnui` verifies its own code signature at startup, so the ELFs are left
untouched (`dontPatchELF`, `dontStrip`). Instead the `vpn` and `vpnui` wrappers
set `NIX_LD` and `NIX_LD_LIBRARY_PATH` from `passthru.libPath`, and the module
mirrors the same list into `programs.nix-ld.libraries`. Child processes such as
`acwebhelper` inherit the environment from `vpnui`, so only the two entry points
need wrapping.

**Library notes.**

| Dependency | Why |
| --- | --- |
| `glib-networking` | Provides `libgiognutls.so`, webkit's GIO TLS backend. Without it `acwebhelper` fails every SAML navigation with `Failed to load page: TLS support is not available`, which the UI reports as an SSO-URL error. It belongs in `buildInputs` only — `wrapGAppsHook3` picks it up as a GIO module, it is not an `LD_LIBRARY_PATH` entry. |
| `webkitgtk_4_1` | The embedded browser for SAML SSO. `acwebhelper` `dlopen`s either `libwebkit2gtk-4.1.so.0` or `libwebkit2gtk-4.0.so.37`, so either ABI works. |
| `at-spi2-core` | Also provides `libatk-1.0.so.0` and `libatk-bridge-2.0.so.0`; `atk` and `at-spi2-atk` are aliases for it and listing them only duplicates the path. |
| `libxml2_13` | The blobs want `libxml2.so.2`, which current `libxml2` no longer provides. |
| `nspr`, `nss`, `libnotify`, `dbus`, `xz`, `systemd` | `dlopen`ed rather than `DT_NEEDED`, so they have to be forced onto the search path. |

`vpnagentd` has a `DT_NEEDED` on `libaccurl.so.4` but Cisco only ships
`libaccurl.so.4.8.0`, hence the symlink in `installPhase`.

The `.desktop` file is rewritten to point at the wrapped `$out/bin/vpnui`
rather than the absolute `/opt` path.
