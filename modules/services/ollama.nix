{ inputs, ... }:
{
  flake.nixosModules.ollama =
    {
      config,
      pkgs,
      lib,
      userconf,
      ...
    }:

    # REQUIRES PERSISTENT "/var/lib"

    let
      webuiPort = 4180;
      searxPort = 8888;
      hostName = userconf.aiDom;

      pkgsOllama = import inputs.nixpkgs-ollama {
        config.allowUnfree = true;
        config.cudaSupport = true;
      };
    in
    {
      services.ollama = {
        enable = true;
        package = pkgsOllama.ollama-cuda;
        loadModels = [
          "qwen3:0.6b"
          "qwen3.6:latest"
          "glm-4.7-flash:latest"
          "mistral-small3.2:latest"
        ];
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
          engines = [
            {
              name = "duckduckgo";
              disabled = false;
            }
            {
              name = "google";
              disabled = false;
            }
            {
              name = "github";
              disabled = false;
            }
            {
              name = "stackoverflow";
              disabled = false;
            }
          ];
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

          ENABLE_PERSISTENT_CONFIG = "False";

          WEBUI_AUTH = "True";

          ENABLE_SEARCH_QUERY = "True";
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
