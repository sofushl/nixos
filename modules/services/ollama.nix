{
  flake.nixosModules.ollama =
    {
      config,
      pkgs,
      lib,
      userconf,
      ...
    }:
    let
      webuiPort = 4180;
      searxPort = 8888;
      hostName = userconf.aiDom;
    in
    {
      services.ollama = {
        enable = true;
        # Curated for Nvidia T2000 using shared vram
        loadModels = [
          "qwen3-coder:30b" # MoE 30B/3.3B active, ~19GB Q4, 256K ctx — primary coder + tool use
          "gpt-oss:20b" # MoE ~20B, MXFP4 ~14GB — lightest, most headroom for long tool contexts
          # "devstral:24b"       # dense 24B agentic coder (~14GB) — heavier when offloading to RAM
          # "deepseek-coder-v2:16b"  # MoE 16B/2.4B, ~12GB — low-VRAM fallback
          # GLM-4.5-Air is NOT in the official Ollama library. Options if you want it:
          #   - community: "MichelRosselli/GLM-4.5-Air"
          #   - official newer GLM: "glm-4.7-flash"  (verify tag at ollama.com/library)
        ];
        # acceleration = "cuda";
      };

      services.searx = {
        enable = true;
        package = pkgs.searxng;
        redisCreateLocally = true;

        settings = {
          server = {
            port = searxPort;
            bind_address = "127.0.0.1";
            # secret_key MUST be set. Provide it via environmentFile (below),
            # NOT inline — inline puts it in the world-readable Nix store.
            secret_key = "@SEARX_SECRET_KEY@";
          };
          search = {
            # Open WebUI: Queries the JSON API.
            formats = [
              "html"
              "json"
            ];
          };
          # Optional: trim to fast, code-friendly engines.
          # engines = [
          #   { name = "duckduckgo"; disabled = false; }
          #   { name = "google"; disabled = false; }
          #   { name = "github"; disabled = false; }
          #   { name = "stackoverflow"; disabled = false; }
          # ];
        };

        # Substitutes @SEARX_SECRET_KEY@ from a file kept out of the Nix store.
        # Create /etc/searx.env with a line:  SEARX_SECRET_KEY=<run: openssl rand -hex 32>
        environmentFile = "/etc/searx.env";
      };

      services.open-webui = {
        enable = true;
        host = "127.0.0.1";
        port = webuiPort;
        environment = {
          # Point Open WebUI at the local Ollama.
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";

          # --- Web search wiring (SearXNG) ---
          # Newer Open WebUI (>=0.6) renamed these; both sets are shown.
          ENABLE_WEB_SEARCH = "True";
          WEB_SEARCH_ENGINE = "searxng";
          # Legacy names (harmless to keep if you're on an older build):
          ENABLE_RAG_WEB_SEARCH = "True";
          RAG_WEB_SEARCH_ENGINE = "searxng";

          # The <query> placeholder is required and literal.
          SEARXNG_QUERY_URL = "http://127.0.0.1:${toString searxPort}/search?q=<query>";

          # How many results get pulled into context per search.
          WEB_SEARCH_RESULT_COUNT = "5";
          WEB_SEARCH_CONCURRENT_REQUESTS = "10";

          WEBUI_AUTH = "True";
          # Behind nginx on a single host; relax if you see CORS/websocket issues.
          # WEBUI_URL = "http://${hostName}";
        };
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;

        virtualHosts.${hostName} = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString webuiPort}";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_read_timeout 600s;
              proxy_send_timeout 600s;
              client_max_body_size 100M;
            '';
          };
        };
      };
    };
}
