# Machine specific configurations

[nixos.nix](./nixos.nix) builds one nixosConfiguration per host in [lib/hosts.nix](../../lib/hosts.nix).
Each host imports its system module from [systems](./systems/):

- [T2000](./systems/T2000.nix) is a HP workstation with a nvidia T2000 gpu sitting at my house running some services.
- [Zbook](./systems/Zbook.nix) is a laptop with a nvidia gpu, dual monitors and gaming.
- [Elitebook](./systems/Elitebook.nix) is a laptop with a fingerprint reader.
- [Aspire](./systems/Aspire.nix) is a laptop with a minimal niri desktop.
- [Lenovo](./systems/Lenovo.nix) is a laptop with a minimal niri desktop.
- [wsl](./systems/wsl.nix) is my WSL config for my single windows gaming pc (also a HP workstation but with a nvidia Quadro RTX 4000 gpu).
- [init](./systems/init.nix) is a minimal config made to minimise installation size during install, root password is "p".

[home.nix](./home.nix) builds one standalone homeConfiguration per home in [lib/homes.nix](../../lib/homes.nix).
NixOS hosts use the same presets through the `home` field of each host.
Each preset lives in [homes](./homes/):

- [headless](./homes/headless.nix) is terminal only, used by servers and WSL.
- [niri-min](./homes/niri-min.nix) is a minimal niri desktop.
- [niri-max](./homes/niri-max.nix) is a full niri desktop with extra tools.
- [work](./homes/work.nix) is my home-manager config for my laptop at work running ubuntu.
