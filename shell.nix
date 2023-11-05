let
  fetchTarball = builtins.fetchTarball;
  stabletar = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.05.tar.gz";
  };
  unstabletar = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  };
  stablepkgs = import stabletar {};
  unstablepkgs = import unstabletar {};
in
stablepkgs.mkShell {
  packages = [
    stablepkgs.git
    stablepkgs.neovim
    stablepkgs.nodejs
    unstablepkgs.nixd
  ];
}