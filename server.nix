{ pkgs, ... }:

{

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
    allowedUDPPorts = [ ];
  };

  # Enable SSH server
  services.openssh = {
    enable = true;
    allowSFTP = true;

    # Security baseline (do this from the start)
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };
}
