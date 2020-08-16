{ ... }:
let

in
{
  imports = [ ./yggdrasil.nix ];

  systemd = {
    targets = {
      neksis = {
        description = "neksis network online";
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
      };
    };

  };
}
