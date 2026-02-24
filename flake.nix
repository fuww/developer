{
  description = "FashionUnited Developer Portal development environment";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  # Flake outputs
  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });

      beadsRustVersion = "0.1.19";
      beadsRustHashes = {
        "x86_64-linux" = "sha256-61a0IeR+NI56GDJdIQlxeiQ3wqNneAe1gUPzAz5oTMw=";
        "x86_64-darwin" = "sha256-98srAx9fRr7NDbzVjIs4za7KONicVgPkZEimSaZ85/w=";
        "aarch64-darwin" = "sha256-p8cZ6+c4LUSMU1Cvz+lus6NfYYTWFilCD2Jt2G+PGSg=";
      };
      beadsRustTargets = {
        "x86_64-linux" = "linux_amd64";
        "x86_64-darwin" = "darwin_amd64";
        "aarch64-darwin" = "darwin_arm64";
      };
    in
    {
      # Development environment output
      devShells = nixpkgs.lib.genAttrs allSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
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
        in {
          default = pkgs.mkShell {
            # The Nix packages provided in the environment
            packages = with pkgs; [
              bun
              nixpkgs-fmt
              beads-rust
            ];

            shellHook = ''
              echo "  Beads:       $(br --version)"
            '';
          };
        });
    };
}
