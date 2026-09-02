let
  homes = import ./homes.nix;
  resolvehome = builtins.mapAttrs (_: h: homes.default // h) homes.homes;
  homeconf = resolvehome.laptop;
in
{
  default = {
    username = homeconf.username;
    displayname = homeconf.displayname;
    pinhash = "$6$INVALID$PLACEHOLDER";
    key = null;

    host = "init";
    path = "/home/sofushl/nixos";
    state = "26.11";
    wifiboard = "wlp0s20f3";
    disk = "sda";
    modules = [
      "niri"
      "greetd-niri"
    ];
  };

  hosts = {
    Acer = {
      host = "Acer";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCfUfHZ/WX05U6bH3Jvf/OxLxEWQlTX6mipQZ8vBjNl sofushl@Acer";
      disk = "nvme0n1";
    };
    Elitebook = {
      host = "Elitebook";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPEKgCTtW184uMBhL2ijmA2sDibWJN1Lln3y6NC61og sofushl@Elitebook";
      disk = "nvme0n1";
    };
    Lenovo = {
      host = "Lenovo";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWrMHaQJytYaXu8akiijr+eAs+Psa1w6T0yLawLMk4d sofushl@Lenovo";
      wifiboard = "wlp0s26u1u4i2";
    };
  };
}
