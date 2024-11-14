{ config, pkgs, lib, ... }: {

  # global package list
  environment.systemPackages = with pkgs; [ neovim ];

  # needed for flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  services = { openssh.enable = true; };

  # enable sudo - passwordless -
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

}
