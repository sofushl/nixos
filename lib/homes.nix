{
  default = rec {
    username = "sofushl";
    displayname = "Sofus Lind";
    email = "sofushl@proton.me";
    workmail = "sofus.lind@nordicsemi.no";
    studmail = "sofushl@stud.ntnu.no";
    type = "default";
    ghname = username;
    nextcloud = "cloud.sofus.privatedns.org";
    nextclouduser = username;
    key = null;
    path = "/home/sofushl/nixos";
    state = "26.11";
    system = "x86_64-linux";
    browser = "librewolf";
    terminal = "kitty";
  };

  homes = {
    headless = {
      type = "headless";
    };

    niriMax = {
      type = "niriMax";
    };

    niriMin = {
      type = "niriMin";
    };

    work = {
      type = "work";
      username = "soli";
      path = "home/soli/nixos";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN73JXdOkCMd8Jl34UVaNv5UfyLqwVgU56dD1qHmQSTO soli@Thinkso.nordicsemi.no";
    };
  };
}
