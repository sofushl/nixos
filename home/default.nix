{ userconf, ... }:
{
  home.username = userconf.username;
  home.stateVersion = userconf.state;
  home.homeDirectory = "/home/${userconf.username}";
}
