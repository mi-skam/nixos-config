{ lib, config, pkgs, ... }:

let cfg = config.adminUser;
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
    programs.fish.enable = true;

    users = {
      mutableUsers = false;
      users.${cfg.name} = {
        isNormalUser = true;
        extraGroups = [ "video" "wheel" ];
        hashedPassword =
          "$y$j9T$r0JcxhNB3XBJF6G.clp3T/$j9Xq5CCtzsPB9ApR/uDBfuKxEYo6qHbHJ0WAag30E/6";
        description = "admin user";
        uid = 1000;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOoDcrEfZmKZvNRd7zp6RlVER/zVQd8hNPoKT3rpJa0+ plumps@mbp"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD5C1ThA1A5FB+3WSkPT6zeMLf69PUgVk/1vwyPzMVwBPpTtwauWapkW3Lex2J587ThKXJZdtE2szMdjukgXpyUerzySVr6SlMZGiFc5+8cZYRlMEiImNoBQx93HOUUBZzGmWay5GVD0uZucgo+PcAUA1D7tQkufryxSHHrxUPvOciZejwzXRa9WtnhfMu3bhuJjmKX8/Sm0LaEBTlFw/FNXCxnACYmONDr5/oHUhEjRrgVUGH1eRbjo2swcKVdBAiGD+eYusFEK5dFPGFX3pv5+aPo134HFENub3XJUPo178wLtxx4I06CpSopMc+SOJvEUzV22zo3hC/Mhxo8Ir2Dx+UHR2lpt3UclyJj9aP3dtnpAp8g/N+7Dzh3VZ62AP+a5uY50rlPsAWNUUarQZ0zE0Vx36bkMrfF0/MSj1M6ErIz8ryubDFBDYvVH8fipIBO7d4bEwQtbrVkT6nqPuCYPxtrrzK6y4RPx2eMKoHX/Z4M6Ov1K9PQGYFiscNfghc= plumps@MBP-von-plumps"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGQAEc4/lVfw4EI3m4dfTXd+UneKZQN3Xtm89uKmF3UXmk8ggzy2ur9KSeikeV3qh4xV1R6q74vdZ8UfJQXZXwTpm9yL9lD0BzTqPrEoTXMJZQMD/TV+WBjgba4oiTyhCh9b1Ww6XchibzQ3ConyVy20jrLVaZE6wKMFcjIRWeTXQqFr5l0s0kGOVBIF1RTDVkg9BlXqiiGhLy5xgEh4ArgdWnGnkI22yQ8UlrXnOxcSma31mGtWTciuUjEHPH3/B/Ke6EPdURDv0ZW0Q0C+eixg2XefePndCEqTGs92/L8QuDIR0cf+RHvFYJJ468ouhUPmIXpCxxEmiYX4aPmWVH"
        ];
        shell = pkgs.fish;
      };
    };
  };
}
