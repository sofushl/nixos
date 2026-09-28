{
  default = rec {
    username = "sofushl";
    displayname = "Sofus Lind";
    email = "sofushl@proton.me";
    gitmail = email;
    localgitname = "Sofus Højberg Lind";
    localgitmail = "sofushl@stud.ntnu.no";
    type = "headless";
    ghname = username;
    nextcloud = "cloud.sofus.privatedns.org";
    nextclouduser = username;
    key = null;
    path = "/home/sofushl/nixos";
    state = "26.11";
    system = "x86_64-linux";
  };

  homes = {
    integrated = {
      type = "integrated";
    };

    work = {
      type = "work";
      username = "soli";
      path = "home/soli/nixos";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN73JXdOkCMd8Jl34UVaNv5UfyLqwVgU56dD1qHmQSTO soli@Thinkso.nordicsemi.no";
      localgitname = "Sofus Lind";
      localgitmail = "sofus.lind@nordicsemi.no";
    };
  };
}
