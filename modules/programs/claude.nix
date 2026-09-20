{
  flake.homeModules.claude =
    {
      pkgs,
      lib,
      userconf,
      ...
    }:

    # REQUIRES PRESERVATION OF "$HOME/.claude.json" "$HOME/.claude/"

    let
      vscodeLangservers = pkgs.vscode-langservers-extracted;

      statusLine = pkgs.writeShellApplication {
        name = "claude-statusline";
        runtimeInputs = [
          pkgs.jq
          pkgs.git
          pkgs.coreutils
        ];
        text = ''
          payload=$(cat)
          model=$(printf '%s' "$payload" | jq -r '.model.display_name // "?"')
          dir=$(printf '%s' "$payload" | jq -r '.workspace.current_dir // .cwd // "."')
          context=$(printf '%s' "$payload" | jq -r '.context_window.used_percentage // empty')
          branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || true)

          printf '[%s] %s' "$model" "$(basename "$dir")"
          if [ -n "$branch" ]; then
            printf ' (%s)' "$branch"
          fi
          if [ -n "$context" ]; then
            printf '  %.0f%% context' "$context"
          fi
        '';
      };
    in
    {
      home.packages = [ pkgs.claude-monitor ];

      programs.claude-code = {
        enable = true;
        package = pkgs.claude-code;

        settings = {
          modelSettings = {
            "claude-sonnet-5".effortLevel = "medium";
            "claude-opus-5".effortLevel = "medium";
          };
          showThinkingSummaries = true;
          switchModelsOnFlag = true;
          theme = "dark";

          statusLine = {
            type = "command";
            command = lib.getExe statusLine;
          };

          editorMode = "vim";
          viewMode = "verbose";
          outputStyle = "default";

          verbose = true;
          showTurnDuration = true;
          showMessageTimestamps = true;
          spinnerTipsEnabled = true;
          todoFeatureEnabled = true;
          terminalTitleFromRename = true;
          prefersReducedMotion = false;
          syntaxHighlightingDisabled = false;

          autoCompactEnabled = true;
          precomputeCompactionEnabled = true;

          cleanupPeriodDays = 30;
          fileCheckpointingEnabled = true;
          autoMemoryEnabled = true;

          env = {
            DISABLE_AUTOUPDATER = "1";
            PAGER = "cat";
          };

          respectGitignore = true;
          defaultShell = "bash";
          permissions.defaultMode = "default";

          # Never allowed, whatever else matches.
          permissions.deny = [
            "Read(**/.env)"
            "Read(**/.env.*)"
            "Read(**/secrets/**)"
            "Read(**/*.age)"
            "Read(~/.ssh/**)"
            "Read(~/.gnupg/**)"
            "Bash(rm -rf /*)"
          ];

          # Always prompt, even in permissive modes.
          permissions.ask = [
            "Bash(sudo *)"
            "Bash(nixos-rebuild *)"
            "Bash(nix-collect-garbage *)"
            "Bash(git push *)"
            "Bash(git reset --hard *)"
          ];

          permissions.allow = [
            # Nix evaluation and introspection
            "Bash(nix eval *)"
            "Bash(nix-instantiate --eval *)"
            "Bash(nix search *)"
            "Bash(nix flake show *)"
            "Bash(nix flake metadata *)"
            "Bash(nix path-info *)"
            "Bash(nix why-depends *)"
            "Bash(nix derivation show *)"
            "Bash(nix store ls *)"
            "Bash(nixos-option *)"
            "Bash(nixfmt --check *)"

            # Git, read-only subcommands
            "Bash(git status *)"
            "Bash(git diff *)"
            "Bash(git log *)"
            "Bash(git show *)"
            "Bash(git blame *)"
            "Bash(git ls-files *)"
            "Bash(git rev-parse *)"
            "Bash(git describe *)"
            "Bash(git shortlog *)"
            "Bash(git show-ref *)"
            "Bash(git stash list *)"
            "Bash(git branch --list *)"
            "Bash(git tag --list *)"

            # Filesystem and host metadata
            "Bash(ls *)"
            "Bash(stat *)"
            "Bash(tree *)"
            "Bash(df *)"
            "Bash(du *)"
            "Bash(readlink *)"
            "Bash(realpath *)"
            "Bash(command -v *)"
            "Bash(which *)"
            "Bash(uname *)"
            "Bash(nproc *)"
            "Bash(lscpu *)"
            "Bash(lsblk *)"
            "Bash(free *)"
            "Bash(uptime *)"

            # Systemd unit state
            "Bash(systemctl list-units *)"
            "Bash(systemctl is-active *)"
            "Bash(systemctl is-enabled *)"
          ];
        };

        mcpServers.nixos = {
          type = "stdio";
          command = lib.getExe pkgs.mcp-nixos;
        };

        # Mirrors the servers in dotfiles/nvim/lsp
        lspServers = {
          asm = {
            command = lib.getExe pkgs.asm-lsp;
            extensionToLanguage = {
              ".s" = "asm";
              ".asm" = "asm";
            };
          };

          clangd = {
            command = lib.getExe' pkgs.clang-tools "clangd";
            extensionToLanguage = {
              ".c" = "c";
              ".h" = "c";
              ".cpp" = "cpp";
              ".cc" = "cpp";
              ".cxx" = "cpp";
              ".hpp" = "cpp";
              ".hh" = "cpp";
            };
          };

          css = {
            command = lib.getExe' vscodeLangservers "vscode-css-language-server";
            args = [ "--stdio" ];
            extensionToLanguage = {
              ".css" = "css";
              ".scss" = "scss";
              ".less" = "less";
            };
          };

          html = {
            command = lib.getExe' vscodeLangservers "vscode-html-language-server";
            args = [ "--stdio" ];
            extensionToLanguage = {
              ".html" = "html";
            };
          };

          json = {
            command = lib.getExe' vscodeLangservers "vscode-json-language-server";
            args = [ "--stdio" ];
            extensionToLanguage = {
              ".json" = "json";
              ".jsonc" = "jsonc";
            };
          };

          java = {
            command = lib.getExe pkgs.jdt-language-server;
            extensionToLanguage = {
              ".java" = "java";
            };
          };

          lua = {
            command = lib.getExe pkgs.lua-language-server;
            extensionToLanguage = {
              ".lua" = "lua";
            };
            settings.Lua = {
              diagnostics.globals = [ "vim" ];
              workspace.library = [ "${pkgs.neovim-unwrapped}/share/nvim/runtime/lua" ];
              telemetry.enable = false;
            };
          };

          markdown = {
            command = lib.getExe pkgs.marksman;
            extensionToLanguage = {
              ".md" = "markdown";
            };
          };

          nix = {
            command = lib.getExe pkgs.nil;
            extensionToLanguage = {
              ".nix" = "nix";
            };
          };

          python = {
            command = lib.getExe' pkgs.pyright "pyright-langserver";
            args = [ "--stdio" ];
            extensionToLanguage = {
              ".py" = "python";
              ".pyi" = "python";
            };
          };

          rust = {
            command = lib.getExe pkgs.rust-analyzer;
            extensionToLanguage = {
              ".rs" = "rust";
            };
          };

          typescript = {
            command = lib.getExe pkgs.typescript-language-server;
            args = [ "--stdio" ];
            extensionToLanguage = {
              ".ts" = "typescript";
              ".tsx" = "typescriptreact";
              ".js" = "javascript";
              ".jsx" = "javascriptreact";
              ".mjs" = "javascript";
              ".cjs" = "javascript";
            };
          };

          typst = {
            command = lib.getExe pkgs.tinymist;
            extensionToLanguage = {
              ".typ" = "typst";
            };
          };

          yaml = {
            command = lib.getExe pkgs.yaml-language-server;
            args = [ "--stdio" ];
            extensionToLanguage = {
              ".yaml" = "yaml";
              ".yml" = "yaml";
            };
          };
        };

        enableMcpIntegration = true;

        rules = {
          "nix" = ''
             - Host config lives in ${userconf.path}, a flake-parts repo; modules under `modules/`, dotfiles under `dotfiles/`.
             - Prefer `nix eval` or the nixos MCP server over guessing option names and package attributes.
             - Never run `nixos-rebuild switch` unprompted; propose the command instead.

            - One module per file; keep related options grouped.
            - Use `lib.getExe` / `lib.getExe'` instead of hardcoding a package's `/bin/...` path.
          '';
        };
      };
    };
}
