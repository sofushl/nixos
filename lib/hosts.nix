let
  homes = import ./homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  homeconf = resolvehome.laptop;
in
{
  default = {
    username = homeconf.username;
    displayname = homeconf.displayname;
    key = null;

    host = "init";
    path = "/home/sofushl/nixos";
    state = "26.11";
    wifiboard = "wlp0s20f3";
    disk = "sda";
    home = "default";
    macaddress = null;
    system = "x86_64-linux";
  };

  hosts = {

    T2000 = {
      host = "T2000";
      path = "/home/sofushl/nixos";
      state = "26.11";
      disk = "nvme0n1";
      wifiboard = "eth";

      macaddress = "48:9e:bd:75:c0:68";
    };
    Aspire = {
      host = "Aspire";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSIsf/7nVF/zBnRUB2ekOhECX7S1H75lq+8l+idSjbC sofushl@Aspire";
      disk = "nvme0n1";
    };
    Elitebook = {
      host = "Elitebook";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH7TP6uO6pyFPdxJiXE69dL49GHgB0pDDiMKxuCCNCTP sofushl@Elitebook";
      disk = "nvme0n1";
    };
    Zbook = {
      host = "Zbook";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBy09roMaMEGDDAw8M7eEjHbmxlyiPBAgoOxh6N5qou+ sofushl@Zbook";
      disk = "nvme1n1";
    };

    Lenovo = {
      host = "Lenovo";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWrMHaQJytYaXu8akiijr+eAs+Psa1w6T0yLawLMk4d sofushl@Lenovo";
      wifiboard = "wlp0s26u1u4i2";
    };

    WSL = {
      host = "WSL";
      wifiboard = "eth0";
    };

    init = {
      host = "init";
    };
  };
}
