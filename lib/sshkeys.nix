rec {
  wslkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICcW+Me6dHxyYPWni5w9YBfHOunyGbTwrHHNK6MLtp2B sofushl@nixos";
  zbookkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVOm4q1/v7MNNsnf6iNlFYUXsV/kxkAzmleWgd6JOr7 sofushl@ZBook";
  acerkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJhDdme6ytH5h5Pfmkr7S2y1oq5tkSsgH9sv3z11C2Vl sofushl@Acer";
  lenovokey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlOmYM6fPUSpez3tWmoxbXij+dakU0r1FNKpZjHJEsn sofushl@Lenovo";

  sshkeys = [
    wslkey
    zbookkey
    acerkey
    lenovokey
  ];

}
