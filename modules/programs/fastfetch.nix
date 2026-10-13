{
  flake.homeModules.fastfetch = { pkgs, ... }: {
    programs.fastfetch = {
      enable = true;

      settings = {
        logo = {
          type = "kitty-direct";
          source = "${pkgs.nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake.png";
          width = 18;
          height = 9;
          padding.right = 2;
          padding.left = 1;
        };

        display = {
          separator = "";
          disableLinewrap = true;
          key.type = "string";
          percent.type = 1;
        };

        modules = [
          {
            type = "command";
            key = "{#38;2;82;119;195} ";
            text = ". /etc/os-release; echo \"$PRETTY_NAME  $(uname -sr)\"";
          }
          {
            type = "host";
            key = "{#38;2;126;186;228}󰌢 ";
          }
          {
            type = "cpu";
            key = "{#38;2;82;119;195} ";
          }
          {
            type = "command";
            key = "{#38;2;126;186;228}󰾲 ";
            text = "fastfetch --pipe false -c ~/.config/fastfetch/gpu.json | sed 's/$/ /' | paste -sd' '";
          }
          {
            type = "command";
            key = "{#38;2;82;119;195} ";
            text = "fastfetch --pipe false -c ~/.config/fastfetch/disk.json | sed 's/$/ /' | paste -sd' '";
          }
          {
            type = "command";
            key = "{#38;2;126;186;228} ";
            text = "fastfetch --pipe false -c ~/.config/fastfetch/mem.json | paste -sd' '";
          }
          {
            type = "battery";
            key = "{#38;2;82;119;195} ";
          }
          {
            type = "packages";
            key = "{#38;2;126;186;228}󰏖 ";
          }
          {
            type = "uptime";
            key = "{#38;2;82;119;195} ";
          }
        ];
      };
    };

    xdg.configFile = {
      "fastfetch/gpu.json".text = ''
        { "logo": {"type": "none"}, "display": {"separator": "", "percent": {"type": 1}, "key": {"type": "string"}}, "modules": [
          { "type": "gpu", "key": "{#38;2;126;186;228}", "format": "{vendor} {name}" } ] }
      '';
      "fastfetch/disk.json".text = ''
        { "logo": {"type": "none"}, "display": {"separator": "", "percent": {"type": 1}, "key": {"type": "string"}}, "modules": [
          { "type": "disk", "key": "{#38;2;82;119;195}", "showRegular": true, "showExternal": true, "format": "{filesystem} {size-used}/{size-total}" } ] }
      '';
      "fastfetch/mem.json".text = ''
        { "logo": {"type": "none"}, "display": {"separator": "", "percent": {"type": 1}, "key": {"type": "string"}}, "modules": [
          { "type": "memory", "key": "{#38;2;126;186;228}", "format": "{used}/{total} ({percentage})" },
          { "type": "swap", "key": "{#38;2;126;186;228}  ", "format": "{used}/{total} ({percentage})" } ] }
      '';
    };
  };
}
