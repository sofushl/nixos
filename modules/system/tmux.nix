# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.nixosModules.tmux = {
    programs.tmux = {
      enable = true;
      clock24 = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 50000;
      terminal = "tmux-256color";
      extraConfig = ''
        set -g mouse on      
        set -g status-right "#S | %H:%M"
      '';
    };

  };
}
