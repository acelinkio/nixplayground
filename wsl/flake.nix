{
  description = "SpecialSnowflake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixoswsl.url = "github:nix-community/NixOS-WSL";
  inputs.nixoswsl.inputs.nixpkgs.follows = "nixpkgs";
  inputs.vscode-server.url = "github:nix-community/nixos-vscode-server";

  outputs = { 
    self,
    nixpkgs,
    nixoswsl,
    vscode-server,
    ...
    }: {


    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixoswsl.nixosModules.wsl
        vscode-server.nixosModules.default
        ({ pkgs, ... }: {
          system = {
            stateVersion = "23.05";
          };
          programs.nix-ld.enable = true;
          services.vscode-server.enable = true;
          environment.systemPackages = [
            pkgs.wget
          ];

          wsl = {
            enable = true;
            defaultUser = "nixos";
            extraBin = with pkgs; [
              { src = "${coreutils}/bin/uname"; }
              { src = "${coreutils}/bin/dirname"; }
              { src = "${coreutils}/bin/readlink"; }
            ];
          };

          nix = {
            settings.experimental-features = [ "nix-command" "flakes" ];
            gc.automatic = true;
            gc.options = "--delete-older-than 7d";
          };
        })
      ];
    };
  };
}
