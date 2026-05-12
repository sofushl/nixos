# NixOS Dendritic Config
My attempt at making my nixos config dendritic. I don't know if its correctly done...

Should be cleaner and more managable than [the old config](https://github.com/sofuslind/nixos-old).


## userconf import

This system is meant for one single user and user configuration relies on ```./lib/sofushl.nix```

userconf includes a user part (sofushl.nix), a host part and a secret part:

Make ```/etc/nixos/secrets.nix``` like this:

```
{
  email = "youremail@example.com";
  password = "yourpassword";
  pin = "yourpin";
}
```

