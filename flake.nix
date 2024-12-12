{
  description = "Environment for building, synthesizing and simulating Opentitan.";
  inputs = {
    # Official NixOS package source, using nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    lowrisc-it = {
      url = "git+ssh://git@github.com/lowrisc/lowrisc-it";
    };

    lowrisc-nix = {
      url = "github:lowrisc/lowrisc-nix";
    };
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
        extraPkgs = with inputs.nixpkgs.legacyPackages.x86_64-linux; [google-cloud-sdk rustup rust-analyzer libcap2];
      };
    };
  };
}
