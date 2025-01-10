{ config, pkgs, lib, ... }: {

  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos
    ../../modules/user.nix
  ];

  networking = {
    hostName = "shit-de-blk-srv-01";
    interfaces.enp0s31f6.useDHCP = true;
  };

  system.stateVersion = "23.11";

}