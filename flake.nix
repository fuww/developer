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
    in
    {
      # Development environment output
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          # The Nix packages provided in the environment
          packages = with pkgs; [
              bun
              nixpkgs-fmt
              go
          ];

          shellHook = ''
            if ! command -v bd &> /dev/null; then
              echo "Installing beads (bd) for AI agent task tracking..."
              go install github.com/steveyegge/beads/cmd/bd@latest
            fi
            echo "  Beads:       $(bd --version 2>/dev/null || echo 'run: go install github.com/steveyegge/beads/cmd/bd@latest')"
          '';
        };
      });
    };
}
