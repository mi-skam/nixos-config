{ lib, config, pkgs, ... }:

let
  cfg = config.adminUser;
  readKeysFromFile = filePath: lib.pipe filePath [
    builtins.readFile
    (builtins.split "\n")
    (builtins.filter (e: builtins.isString(e) && e != ""))
  ];
in {
  options = {
    adminUser.enable = lib.mkEnableOption "enable adminUser module";

    adminUser.name = lib.mkOption {
      default = "admin";
      description = ''
        name of the user
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = false;
      users.${cfg.name} = {
        isNormalUser = true;
        extraGroups = [ "video" "wheel" ];
        hashedPassword =
          "$y$j9T$r0JcxhNB3XBJF6G.clp3T/$j9Xq5CCtzsPB9ApR/uDBfuKxEYo6qHbHJ0WAag30E/6";
        description = "admin user";
        uid = 1000;
        openssh.authorizedKeys.keys = readKeysFromFile ./ssh.keys;
      };
    };
  };
}
