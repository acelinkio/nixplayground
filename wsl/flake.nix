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
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixoswsl.nixosModules.wsl
        vscode-server.nixosModules.default
        home-manager.nixosModules.home-manager
        # homemanager inline
        (
          { pkgs, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # note that 'nixos' is user
            home-manager.users.nixos = {
              home.username = "nixos";
              home.homeDirectory = "/home/nixos";
              home.stateVersion = "23.05";
              home.packages = [                               
                pkgs.alejandra  # nix formatter
                pkgs.nil        # nix language server
              ];
              programs.home-manager.enable = true;
            };
          }
        )
        # wsl inline
        (
          { pkgs, ... }: {
            wsl = {
              enable = true;
              defaultUser = "nixos";
              # workaround for vscode remoting
              extraBin = with pkgs; [
                { src = "${coreutils}/bin/uname"; }
                { src = "${coreutils}/bin/dirname"; }
                { src = "${coreutils}/bin/readlink"; }
              ];
            };
          }
        )
        # nixos inline
        (
          { pkgs, ... }: {
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
            nix = {
              settings.experimental-features = [ "nix-command" "flakes" ];
              gc.automatic = true;
              gc.options = "--delete-older-than 7d";
            };
          }
        )
        # vscode remoting inline
        (
          { pkgs, ... }: {
            programs.nix-ld.enable = true;
            services.vscode-server.enable = true;
          }
        )
      ];
    };
  };
}
