{
  flake.homeModules.yazi = {
    programs = {
      yazi = {
        enable = true;
        enableBashIntegration = true;

        settings = {

          mgr = {
            show_hidden = false;
            sort_dir_first = true;
            sort_reverse = false;
          };
        };
      };
    };
  };
}
