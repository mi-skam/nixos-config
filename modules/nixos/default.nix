{ config, pkgs, lib, ... }: {

  # needed for flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  adminUser = {
    enable = true;
    name = "plumps";
  };

  console.keyMap = "neo";

  environment.systemPackages = with pkgs; [
    wget
    htop
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
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
    xserver = {
      layout = "de";
      xkbVariant = "neo";
    };
  };

  # enable sudo - passwordless -
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  time.timeZone = "Europe/Berlin";

}
