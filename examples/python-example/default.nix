let
  pkgs = import <nixpkgs> {};
  build = pkgs.python3Packages.callPackage ./package.nix {};
in
  {
    inherit build;

    shell = pkgs.mkShell {
      inputsFrom = [ build ];

      packages = with pkgs; [
        curl
        hurl
      ];

      pythonpackages = with pkgs.python3Packages; [
        black
        flake8
      ];
    };
  }
