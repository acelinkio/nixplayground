# nixplayground
My exploration into the Nix language and creating references along the way.

```sh
## WSL SETUP
#psh
wsl --shutdown
wsl --unregister nixos
wsl --list --running
wsl --list
wsl --import nixos .\nixos\ nixos-wsl.tar.gz --version 2
wsl --distribution nixos

## FLAKE
# sh
cp ./wsl/flake.nix ~/
sudo nixos-rebuild switch --flake ~/.
exit

#psh
wsl --terminate nixos
wsl --list --running
wsl --distribution nixos
```