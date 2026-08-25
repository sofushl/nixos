rec {
  terminal = "kitty";

  theme = pastelish-red;

  pastelish-red = rec {
    n = {
      black = "#1E1E1E";
      red = "#DC6666";
      green = "#86B895";
      yellow = "#E0B879";
      blue = "#7DAAEA";
      magenta = "#CFA1E8";
      cyan = "#7FC0C4";
      white = "#E3E0E0";
      gray = "#7A7A7A";
    };
    b = {
      black = "#2A2A2A";
      red = "#E87878";
      green = "#98C9A6";
      yellow = "#EDC98C";
      blue = "#93BCF5";
      magenta = "#DCB3F2";
      cyan = "#92D0D4";
      white = "#F2F0F0";
      gray = "#505050";
    };

    bg = {
      primary = n.black;
      secondary = b.black;
      selected = n.red;
    };

    text = {
      primary = n.white;
      secondary = n.gray;
      selected = n.black;
    };

    primary = n.red;
    secondary = n.gray;
    inactive = b.gray;
  };

  theme-vscode = {
    n = {
      base00 = "#1e1e1e"; # editor bg
      base01 = "#252526"; # sidebar/statusbar bg
      base02 = "#264f78"; # selection
      base03 = "#6a9955"; # comments  (see note)
      base04 = "#858585"; # line numbers, dim fg
      base05 = "#d4d4d4"; # default fg
      base06 = "#e7e7e7"; # light fg (interpolated)
      base07 = "#ffffff"; # lightest
      base08 = "#9cdcfe"; # variables
      base09 = "#b5cea8"; # numbers/constants
      base0A = "#4ec9b0"; # types/classes
      base0B = "#ce9178"; # strings
      base0C = "#d16969"; # regex/escapes
      base0D = "#dcdcaa"; # functions
      base0E = "#569cd6"; # keywords
      base0F = "#c586c0"; # control flow / deprecated
    };
    alt = {
      base00 = "#1e1e1e"; # bg
      base01 = "#252526"; # panel/lighter bg
      base02 = "#264f78"; # selection
      base03 = "#6a9955"; # comments
      base04 = "#808080";
      base05 = "#d4d4d4"; # default fg
      base06 = "#e7e7e7";
      base07 = "#ffffff";
      base08 = "#f44747"; # red / errors
      base09 = "#b5cea8"; # numbers
      base0A = "#dcdcaa"; # functions / yellow
      base0B = "#ce9178"; # strings
      base0C = "#4ec9b0"; # types / cyan
      base0D = "#569cd6"; # keywords / blue
      base0E = "#c586c0"; # control keywords / magenta
      base0F = "#d16d9e";
    };
  };
}
