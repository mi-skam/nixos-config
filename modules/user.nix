{ lib, config, pkgs, ...}:

let
  cfg = config.adminUser;
in
{
  options = {
    adminUser.enable =
      lib.mkEnableOption "enable adminUser module";

    adminUser.userName = lib.mkOption {
      default = "plumps";
      description = ''
        name of the user
      '';
    };
  };
  
  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
    
    users = {
      mutableUsers = false;
      users.${cfg.userName} = {
        isNormalUser = true;
        extraGroups = [ "video" "wheel" ];
        hashedPassword =
        "$y$j9T$StxG12FZx9uNm.fXGAzTe.$M0n2IPMHfB3gqVIkwTwfbr7yOc9gIGJDkSAegxFMp52";
        description = "admin user";
        uid = 1000;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILQYngnUuiPEHFBvLK4WQxN5bbw01ns+FSlFSPInFg6N u@windows-1"
        ];
        shell = pkgs.fish;
      };
    };
  };
}