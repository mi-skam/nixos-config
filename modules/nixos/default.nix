{ config, pkgs, lib, ... }: {

  # needed for flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    command-not-found.enable = false;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };

  services = { openssh.enable = true; };

  # enable sudo - passwordless -
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

}
