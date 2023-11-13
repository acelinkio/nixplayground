{ config, pkgs, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "23.05";
  home.packages = [                               
    #nix formatter
    pkgs.alejandra
    #nix language server
    pkgs.nil  
  ];
  programs.home-manager.enable = true;
}