{ config, pkgs, modulesPath, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos
    ../../modules/user.nix

  ];

  adminUser.enable = true;
  adminUser.name = "plumps";

  # Interface is this on my M1
  networking = {
    hostName = "kudos";
    interfaces.enp0s1.useDHCP = true;
    
    firewall.enable = false;
  };

  # For now, we need this since hardware acceleration does not work.
  environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";

  system.stateVersion = "24.05";

  time.timeZone = "Europe/Berlin";

}