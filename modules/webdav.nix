{ config, lib, pkgs, ... }:
let
  app = "webdav";
  appDir = "/var/www/${app}";
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services = {
    # reverse proxy
    caddy = {
      enable = true;
      user = app;
      virtualHosts = {
        "web.marco.miskam.xyz" = {
          extraConfig = ''
            reverse_proxy localhost:4918 {
              header_up Host {host}
              header_up X-Real-IP {remote}
              header_up Connection {>Connection}
              header_up X-Forwarded-Port {port}
              header_up X-Forwarded-Ssl on
            }
          '';
        };
      };
    };
    webdav-server-rs = {
      enable = true;
      user = app;
      settings = {
        server.listen = [ "127.0.0.1:4918" ];
        accounts = {
          auth-type = "htpasswd.default";
          acct-type = "unix";
        };
        htpasswd.default = { htpasswd = "/etc/htpasswd"; };

        location = [
          {
            route = [ "/zotero/*path" ];
            directory = "/var/www/webdav/zotero/";
            handler = "filesystem";
            methods = [ "webdav-rw" ];
            autoindex = true;
            auth = "true";
          }
          {
            route = [ "/obsidian/*" ];
            directory = "/var/www/webdav/obsidian/";
            handler = "filesystem";
            methods = [ "webdav-rw" ];
            autoindex = true;
            auth = "true";
          }
        ];
      };
    };
  };

  # user for caddy and phpfpm
  users.users.${app} = {
    isSystemUser = true;
    createHome = true;
    home = appDir;
    group = app;
  };
  users.groups.${app} = { };
}
