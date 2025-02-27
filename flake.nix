{
  description = "Environment for building, synthesizing and simulating Opentitan.";
  inputs = {
    # Official NixOS package source, using lowrisc-nix here
    nixpkgs.follows = "lowrisc-it/nixpkgs";

    lowrisc-it = {
      url = "git+ssh://git@github.com/lowrisc/lowrisc-it";
    };

    lowrisc-nix = {
      follows = "lowrisc-it/lowrisc-nix";
    };
  };

  nixConfig = {
    extra-substituters = ["https://nix-cache.lowrisc.org/public/"];
    extra-trusted-public-keys = ["nix-cache.lowrisc.org-public-1:O6JLD0yXzaJDPiQW1meVu32JIDViuaPtGDfjlOopU7o="];
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
  in {
    formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.alejandra;
    devShells.x86_64-linux = {
      opentitan = inputs.lowrisc-nix.devShells.x86_64-linux.opentitan.override {
        edaTools = with inputs.lowrisc-it.packages.x86_64-linux; [vcs vivado xcelium];
        extraPkgs = with inputs.nixpkgs.legacyPackages.x86_64-linux; [google-cloud-sdk rustup rust-analyzer zsh];
      };
      cheriot = inputs.lowrisc-nix.devShells.x86_64-linux.cheriot;
      cherititan = inputs.lowrisc-nix.devShells.x86_64-linux.opentitan.override {
        edaTools = with inputs.lowrisc-it.packages.x86_64-linux; [vcs vivado xcelium];
        extraPkgs = (with inputs.nixpkgs.legacyPackages.x86_64-linux; [google-cloud-sdk rustup rust-analyzer zsh])
          ++ inputs.lowrisc-nix.devShells.x86_64-linux.cheriot.nativeBuildInputs;
      };
    };
  };
}
