let
  default = (import ./homes.nix).default;
in
{
  hosts = [
    {
      url = "https://github.com/";
      alias = [
        "gh:"
        "github:"
      ];
    }
    {
      url = "https://github.com/sofushl/";
      alias = [ "shl:" ];
    }
    {
      url = "https://codeberg.org/";
      alias = [ "cb:" ];
    }
    {
      url = "https://git.sofus.privatedns.org/";
      alias = [ "sgit:" ];
    }
  ];
  configs = [
    {
      name = default.displayname;
      email = default.email;
      remote = null;
    }
    {
      name = "Sofus Højberg Lind";
      email = "sofushl@stud.ntnu.no";
      remote = "git@git.ntnu.no:*/**";
    }
    {
      name = "Sofus Lind";
      email = "sofus.lind@nordicsemi.no";
      remote = "https://github.com/nordicsemi/**";
    }
  ];
}
