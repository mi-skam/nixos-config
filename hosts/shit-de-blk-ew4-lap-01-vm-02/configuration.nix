{ config, pkgs, modulesPath, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos
    ../../modules/user.nix

  ];

  networking = {
    hostName = "kudos";
    interfaces.enp0s1.useDHCP = true;

    firewall.enable = false;
  };

  # For now, we need this since hardware acceleration does not work.
  environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";

  system.stateVersion = "24.05";
}
