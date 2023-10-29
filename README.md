# nixplayground
My exploration into the Nix language and creating references along the way.

## Enabling flakes
Add the following line to `/etc/nixos/cnofiguration.nix`
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
then run `sudo nixos-rebuild switch`