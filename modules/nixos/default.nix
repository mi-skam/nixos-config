{ config, pkgs, lib, ... }: {

  # needed for flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  adminUser = {
    enable = true;
    name = "plumps";
  };

  programs = {
    command-not-found.enable = false;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };

  services = {
    openssh.enable = true;
    vscode-server.enable = true;
  };

  # enable sudo - passwordless -
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  time.timeZone = "Europe/Berlin";

}
