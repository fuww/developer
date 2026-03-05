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
      codexVersion = "0.106.0";
      codexHashes = {
        "x86_64-linux" = "sha256-T3D3t3V+JawmyiN1TRGzzLPeGSyCYP1rTylKNcssZ3w=";
      };
      codexVendorDirs = {
        "x86_64-linux" = "x86_64-unknown-linux-musl";
      };
      geminiVersion = "0.31.0";
      geminiHash = "sha256-b/xQN42G06Iu82MOKqLb8ybuBfvdtx/dlefI1YfXVeQ=";
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
        codex = pkgs.stdenv.mkDerivation {
          pname = "codex";
          version = codexVersion;
          src = pkgs.fetchurl {
            url = "https://registry.npmjs.org/@openai/codex/-/codex-${codexVersion}-linux-x64.tgz";
            hash = codexHashes.${system};
          };
          sourceRoot = ".";
          unpackPhase = ''
            tar xzf $src
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp package/vendor/${codexVendorDirs.${system}}/codex/codex $out/bin/codex
            chmod +x $out/bin/codex
          '';
          meta = {
            description = "OpenAI Codex CLI coding agent";
            homepage = "https://github.com/openai/codex";
            license = pkgs.lib.licenses.asl20;
          };
        };
        gemini-cli = pkgs.stdenv.mkDerivation {
          pname = "gemini-cli";
          version = geminiVersion;
          src = pkgs.fetchurl {
            url = "https://github.com/google-gemini/gemini-cli/releases/download/v${geminiVersion}/gemini.js";
            hash = geminiHash;
          };
          dontUnpack = true;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            mkdir -p $out/lib $out/bin
            cp $src $out/lib/gemini.js
            makeWrapper ${pkgs.nodejs}/bin/node $out/bin/gemini \
              --add-flags "$out/lib/gemini.js"
          '';
          meta = {
            description = "Google Gemini CLI coding agent";
            homepage = "https://github.com/google-gemini/gemini-cli";
            license = pkgs.lib.licenses.asl20;
          };
        };
      in {
        default = pkgs.mkShell {
          packages = [
            prek
            beads-rust
            gemini-cli
          ] ++ (pkgs.lib.optionals (codexHashes ? ${system}) [ codex ]) ++ (with pkgs; [
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
