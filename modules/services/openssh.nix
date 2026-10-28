{
  flake.nixosModules.openssh = { userconf, ... }: {
    services.openssh = {
      enable = true;
      allowSFTP = false;
      openFirewall = true;

      settings = {
        PasswordAuthentication = true;
        AuthenticationMethods = "publickey,password";
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ userconf.username ];
        X11Forwarding = false;
      };
    };
  };
}
