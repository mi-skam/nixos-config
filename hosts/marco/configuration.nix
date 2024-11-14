{ config, pkgs, lib, ... }: {

  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos
    ../../modules/webdav.nix
    ../../modules/user.nix
  ];

  adminUser.enable = true;
  adminUser.name = "plumps";

  services.qemuGuest.enable = true;

  services.vscode-server.enable = true;

  networking = {
    hostName = "marco";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    networkmanager.enable = true;
  };

  system.stateVersion = "23.11";

  time.timeZone = "Europe/Berlin";
}
