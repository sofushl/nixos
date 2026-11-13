# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.opencode =
    {
      pkgs,
      lib,
      stablepkgs,
      userconf,
      ...
    }:

    # REQURIES PRESERVATION OF "$HOME/.local/share/opencode" "$HOME/.local/state/opencode" "$HOME/.config/opencode"

    {
      programs.opencode = {
        enable = true;
        package = pkgs.opencode;

        web = {
          enable = true;
        };

        settings = {
          plugin = [
            "opencode-claude-auth@latest"
          ];

          enabled_providers = [
            "litellm"
            "anthropic"
          ];

          provider.omniroute = {
            npm = "@ai-sdk/openai-compatible";
            name = "OmniRoute";
            options = {
              baseURL = "https://${userconf.aiDom}/v1";
              apiKey = "{file:~/.config/opencode/.omniroute}";
            };
            models = {
              "auto".name = "OmniRoute auto";
              "auto/coding".name = "OmniRoute coding";
              "auto/cheap".name = "OmniRoute cheap";
              "auto/fast".name = "OmniRoute fast";
            };
          };

          provider.litellm = {
            npm = "@ai-sdk/openai-compatible";
            name = "NTNU LiteLLM";
            options = {
              baseURL = "https://llm.hpc.ntnu.no/v1";
              apiKey = "{file:~/.config/opencode/.ntnuai}";
            };
            models =
              let
                model = name: input: context: {
                  inherit name;
                  modalities = {
                    inherit input;
                    output = [ "text" ];
                  };
                  limit = {
                    inherit context;
                    output = context / 2;
                  };
                };
                multimodal = [
                  "text"
                  "image"
                ];
              in
              {
                "zai-org/GLM-5.3-Flash" = model "GLM-5.3 Flash" multimodal 699050;
                "Qwen/Qwen3.8-27B-FP8" = model "Qwen3.8 27B FP8" multimodal 174762;
                "Inferact/GLM-5.3-NVFP4" = model "GLM-5.3 NVFP4" [ "text" ] 400000;
                "mistralai/Mistral-Medium-3.5-128B" = model "Mistral Medium 3.5 128B" multimodal 174762;
                "deepseek-ai/DeepSeek-V4.1-Flash-1017" = model "DeepSeek V4.1 Flash" multimodal 699050;
                "moonshotai/Kimi-K2.6" = model "Kimi K2.6" multimodal 174762;
              };
          };
        };

        cli.keybinds = {
          "dialog.select.next" = "j,down,ctrl+n";
          "dialog.select.prev" = "k,up,ctrl+p";
          "dialog.select.home" = "g,home";
          "dialog.select.end" = "shift+g,end";
          "diff.down" = "j,down";
          "diff.up" = "k,up";
        };

        enableMcpIntegration = true;
      };

      home.shellAliases."claude-auth" =
        "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p claude-code --run 'claude && opencode'";
    };
}
