{
  default = rec {
    username = "sofushl";
    displayname = "Sofus Lind";
    email = "sofushl@proton.me";
    gitmail = email;
    ghname = username;
    nextcloud = "cloud.sofus.privatedns.org";
    nextclouduser = username;
    key = null;
    path = "/home/sofushl/nixos";
    state = "26.11";
    modules = [
    ];
  };

  homes = {
    laptop = {
      host = "laptop";
    };

    work = {
      host = "work";
      username = "soli";
      path = "home/soli/nixos";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN73JXdOkCMd8Jl34UVaNv5UfyLqwVgU56dD1qHmQSTO soli@Thinkso.nordicsemi.no";
      modules = [ "work" ];
    };
  };
}
