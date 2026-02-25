{
  description = "FashionUnited Developer Portal development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
      });

      beadsRustVersion = "0.1.14";
      beadsRustHashes = {
        "x86_64-linux" = "sha256-xPR3IDKGjQri4E5KE2KZUcBfFPCbp5H/cOFhXNjrqxs=";
        "aarch64-linux" = "sha256-voOrwmDxlhS0kJXlf9Y5sNghEVriKysLokTbDOGTwgA=";
        "x86_64-darwin" = "sha256-y8Pouq7EasFTCsqmF+NT6UQnhCjmN2fjv/bafKBL11c=";
        "aarch64-darwin" = "sha256-1IJrD3UvqWk2B8jT8JV5oEFrlTE9CHi0nKqyQ7N7LbI=";
      };
      beadsRustTargets = {
        "x86_64-linux" = "linux_amd64";
        "aarch64-linux" = "linux_arm64";
        "x86_64-darwin" = "darwin_amd64";
        "aarch64-darwin" = "darwin_arm64";
      };

      prekVersion = "0.3.3";
      prekHashes = {
        "x86_64-linux" = "sha256-RPYzZ6h/zqvoYrByNARmRc4SFAix7Y6nquANClQMonE=";
        "x86_64-darwin" = "sha256-C2VVXSvSrdaySh8r5Rz+5tDIN4klYLrywhY72vr+0zg=";
        "aarch64-linux" = "sha256-hckriLkcvhVIouYWMq8ASgnH8rtHXANzy7DFI6hI4gQ=";
        "aarch64-darwin" = "sha256-EsHigdTUhOqm1QKATGqMd6sG8f3SLF/UbAL4euXzwa8=";
      };
      prekTargets = {
        "x86_64-linux" = "x86_64-unknown-linux-gnu";
        "x86_64-darwin" = "x86_64-apple-darwin";
        "aarch64-linux" = "aarch64-unknown-linux-gnu";
        "aarch64-darwin" = "aarch64-apple-darwin";
      };
    in
    {
      devShells = forAllSystems ({ pkgs, system }: let
        beads-rust = pkgs.stdenv.mkDerivation {
          pname = "beads-rust";
          version = beadsRustVersion;
          src = pkgs.fetchurl {
            url = "https://github.com/Dicklesworthstone/beads_rust/releases/download/v${beadsRustVersion}/br-v${beadsRustVersion}-${beadsRustTargets.${system}}.tar.gz";
            hash = beadsRustHashes.${system};
          };
          sourceRoot = ".";
          installPhase = ''
            mkdir -p $out/bin
            cp br $out/bin/
            chmod +x $out/bin/br
          '';
          meta = {
            description = "AI-supervised issue tracker (Rust rewrite)";
            homepage = "https://github.com/Dicklesworthstone/beads_rust";
            license = pkgs.lib.licenses.mit;
          };
        };

        prek = pkgs.stdenv.mkDerivation {
          pname = "prek";
          version = prekVersion;
          src = pkgs.fetchurl {
            url = "https://github.com/j178/prek/releases/download/v${prekVersion}/prek-${prekTargets.${system}}.tar.gz";
            hash = prekHashes.${system};
          };
          sourceRoot = ".";
          installPhase = ''
            mkdir -p $out/bin
            cp prek-${prekTargets.${system}}/prek $out/bin/
            chmod +x $out/bin/prek
          '';
          meta = {
            description = "Better pre-commit, re-engineered in Rust";
            homepage = "https://github.com/j178/prek";
            license = pkgs.lib.licenses.mit;
          };
        };
      in {
        default = pkgs.mkShell {
          packages = [
            prek
            beads-rust
          ] ++ (with pkgs; [
            bun
            nixpkgs-fmt
          ]);

          shellHook = ''
            prek install
            echo "  Beads:       $(br --version)"
          '';
        };
      });
    };
}
