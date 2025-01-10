{ config, pkgs, lib, ... }: {

  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos
    ../../modules/webdav.nix
    ../../modules/user.nix
  ];

  networking = {
    hostName = "marco";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    interfaces.ens3.useDHCP = true;
  };

  services.qemuGuest.enable = true;

  system.stateVersion = "23.11";

}
