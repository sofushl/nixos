{
  flake.homeModules.bash = {
    programs.bash = {
      enable = true;

      historyControl = [ "ignoreboth" ];
      historySize = 1000;
      historyFileSize = 2000;

      shellOptions = [
        "histappend"
        "checkwinsize"
      ];

      shellAliases = {
        ls = "ls --color=auto";
        grep = "grep --color=auto";
        fgrep = "fgrep --color=auto";
        egrep = "egrep --color=auto";
        ll = "ls -alF";
        la = "ls -A";
        l = "ls -CF";
        alert = ''notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')"'';
      };

      initExtra = "fastfetch";

      bashrcExtra = ''
        case "$TERM" in
            xterm-color|*-256color) color_prompt=yes;;
        esac
        if [ "$color_prompt" = yes ]; then
            PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        else
            PS1='\u@\h:\w\$ '
        fi
        unset color_prompt
        case "$TERM" in
        xterm*|rxvt*)
            PS1="\[\e]0;\u@\h: \w\a\]$PS1"
            ;;
        esac
      '';
    };
  };
}
