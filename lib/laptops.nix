{
  default = {
    username = "sofushl";
    displayname = "Sofus Lind";
    pinhash = "$y$j9T$/EEjqWS9HnfLJknQuxtzY.$jkG/dUYohj2VtSoacz4dbFhaEjqt61DEVfRDPD48so2";
    key = null;

    host = "init";
    path = "/home/sofushl/nixos";
    state = "26.11";
    wifiboard = "eth0";
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
      wifiboard = "wlp0s20f3";
      disk = "nvme0n1";
    };
    Dell = {
      host = "Dell";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlIjMXWH27j3jHnrXp3fYGw42o6DCDN7MLIdXeAGiCq sofushl@Dell";
      wifiboard = "wlp1s0";
    };
    Lenovo = {
      host = "Lenovo";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWrMHaQJytYaXu8akiijr+eAs+Psa1w6T0yLawLMk4d sofushl@Lenovo";
      wifiboard = "wlp0s26u1u4i2";
    };
  };
}
