{
  description = "Prowlarr patched to sync the arrs' per-indexer download file-type policy";

  inputs = {
    flake-lib.url = "github:jgus-org/flake-lib/v1";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      flake-lib,
      nixpkgs,
      ...
    }:
    flake-lib.lib.eachDefaultLinuxSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        orgFormatting = flake-lib.lib.mkFormatting {
          inherit self system;
        };
      in
      {
        checks.formatting = orgFormatting.check;
        formatter = orgFormatting.formatter;
        packages = rec {
          default = prowlarr;
          prowlarr = pkgs.prowlarr.overrideAttrs (old: {
            doCheck = false;
            patches = (old.patches or [ ]) ++ [ ./patches/prowlarr-sync-fail-downloads.patch ];
          });
        };
      }
    );
}
