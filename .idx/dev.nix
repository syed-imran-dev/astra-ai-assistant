{ pkgs, ... }: {
  # Channel for Nix packages
  channel = "stable-24.05";

  # Defined packages to install in the workstation
  packages = [
    pkgs.flutter
    pkgs.nodejs_20
    pkgs.git
  ];

  # Enable IDX Previews for your apps
  idx.previews = {
    enable = true;
    previews = {
      # You can add web or android preview configs here later
    };
  };
}
