{
  description = "SpecialSnowflake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  inputs.nixoswsl.url = "github:nix-community/NixOS-WSL";
  inputs.nixoswsl.inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.url = "github:nix-community/home-manager/release-23.05";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.vscode-server.url = "github:nix-community/nixos-vscode-server";

  outputs = { 
    nixpkgs,
    nixoswsl,
    home-manager,
    vscode-server,
    ...
    }: {
    #nixos configs
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixoswsl.nixosModules.wsl
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nixos = import ./home.nix;
        }
        vscode-server.nixosModules.default
        ({ pkgs, ... }: {
          system = {
            stateVersion = "23.05";
          };
          environment.systemPackages = [
            pkgs.btop
            pkgs.htop
            pkgs.wget
            pkgs.jq
            pkgs.yq-go
            pkgs.dnsutils
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

          programs.nix-ld.enable = true;
          services.vscode-server.enable = true;
        })
      ];
    };
  };
}
