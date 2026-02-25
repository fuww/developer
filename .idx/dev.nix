# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{pkgs}: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.git
    pkgs.which
    pkgs.htop
    pkgs.nixpkgs-fmt
    pkgs.zlib
    pkgs.nodejs_20
    #pkgs.nodePackages.pnpm # gives pnpm 8
    pkgs.corepack_20 # installs exact packagemanager version mentioned in package.json
  ];
  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "vscodevim.vim"
      "astro-build.astro-vscode"
    ];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        install = ''
          npm install
          '';
          # yes | npx astro add tailwind
      };
      # To run something each time the environment is rebuilt, use the `onStart` hook
    };
    # Enable previews and customize configuration
    previews = {
      enable = true;
      previews = {
        web = {
          # pnpm works as well, but not yet with the port settings
          command = ["npm" "run" "dev" "--" "--port" "$PORT" "--hostname" "0.0.0.0"];
          manager = "web";
        };
      };
    };
  };
}
