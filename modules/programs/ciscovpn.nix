{
  flake.nixosModules.ciscovpn =
    { pkgs, ... }:
    let
      csc = pkgs.callPackage ../../pkgs/cisco-secure-client.nix { };
      prefix = "${csc}/opt/cisco/secureclient";
    in
    {
      environment.systemPackages = [ csc ];

      boot.kernelModules = [ "tun" ];

      programs.nix-ld = {
        enable = true;
        libraries = csc.libDeps;
      };

      systemd.tmpfiles.rules = [
        "d  /opt                                             0755 root root -"
        "d  /opt/cisco                                       0755 root root -"
        "d  /opt/cisco/secureclient                          0755 root root -"
        "L+ /opt/cisco/secureclient/bin                      -    -    -    - ${prefix}/bin"
        "L+ /opt/cisco/secureclient/lib                      -    -    -    - ${prefix}/lib"
        "L+ /opt/cisco/secureclient/resources                -    -    -    - ${prefix}/resources"
        "L+ /opt/cisco/secureclient/ACManifestVPN.xml        -    -    -    - ${prefix}/ACManifestVPN.xml"
        "L+ /opt/cisco/secureclient/AnyConnectProfile.xsd    -    -    -    - ${prefix}/AnyConnectProfile.xsd"
        "L+ /opt/cisco/secureclient/AnyConnectLocalPolicy.xsd -   -    -    - ${prefix}/AnyConnectLocalPolicy.xsd"
        "d  /opt/cisco/secureclient/vpn                      0755 root root -"
        "d  /opt/cisco/secureclient/vpn/profile              0755 root root -"
        "d  /opt/cisco/secureclient/vpn/script               0755 root root -"
        "L+ /bin/systemctl                                   -    -    -    - ${pkgs.systemd}/bin/systemctl"
      ];

      systemd.services.vpnagentd = {
        description = "Cisco Secure Client - AnyConnect VPN Agent";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        path = [
          pkgs.iproute2
          pkgs.kmod
          pkgs.procps
          pkgs.systemd
        ];

        serviceConfig = {
          Type = "simple";
          Environment = [
            "NIX_LD=${pkgs.glibc}/lib/ld-linux-x86-64.so.2"
            "NIX_LD_LIBRARY_PATH=${csc.libPath}"
            "LD_LIBRARY_PATH=${csc.libPath}"
          ];
          ExecStart = "${prefix}/bin/vpnagentd -execv_instance";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          Restart = "on-failure";
          KillMode = "process";
        };
      };
    };
}
