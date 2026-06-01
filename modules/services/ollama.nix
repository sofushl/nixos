{ self, inputs, ... }:

{
  flake.nixosModules.ollama =
    { userconf, ... }:
    {

      services.ollama = {
        enable = true;

        loadModels = [
          "llama3.2:3b"
          "deepseek-r1:1.5b"
          "deepseek-coder:6.7b"
          "phi3:mini"
        ];

      };

      services.open-webui = {
        enable = true;
        host = "127.0.0.1";
        port = 4180;

        #environment = {
        #  ENABLE_RAG_WEB_SEARCH = "True";
        #  ENABLE_SEARCH_QUERY = "True";
        #  WEBUI_AUTH = "True";
        #};
      };

      services.searx = {
        enable = false;
        domain = userconf.searchDom;
        configureNginx = true;
        configureUwsgi = true;
      };
    };
}
