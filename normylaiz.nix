{ config, kor, hyraizyn, pkgs, lib, ... }:
let
  inherit (kor) mapAttrsToList eksportJSON;
  inherit (lib) concatStringsSep mkOverride;
  inherit (pkgs) mksh;
  inherit (hyraizyn) astra exAstriz;

  jsonHyraizynFail = eksportJSON "hyraizyn.json" hyraizyn;
  chipSetIsIntel = true; # TODO

  uniksOSShell = mksh + mksh.shellPath;

  mkAstriKnownHost = n: astri:
    concatStringsSep " " [ astri.uniksNeim astri.eseseitc ];

  sshKnownHosts = concatStringsSep "\n"
    (mapAttrsToList mkAstriKnownHost exAstriz);

in
{
  boot = {
    kernelParams = [ "consoleblank=300" ];

    kernelPackages = pkgs.linuxPackages_latest;

    supportedFilesystems = mkOverride 50 [ "xfs" "btrfs" ]; # TODO remove btrfs
  };

  documentation = {
    enable = !config.boot.isContainer;
    nixos.enable = !config.boot.isContainer;
  };

  environment = {
    binsh = uniksOSShell;
    shells = [ "/run/current-system/sw${mksh.shellPath}" ];

    etc = {
      "ssh/ssh_known_hosts".text = sshKnownHosts;
      "hyraizyn.json" = {
        source = jsonHyraizynFail;
        mode = "0600";
      };
    };

    systemPackages = [
      termite.terminfo
      pkgs.lm_sensors
    ];
  };

  networking = {
    hostName = astra.neim;
    dhcpcd.extraConfig = "noipv4ll";
  };

  hardware = {
    cpu.intel.updateMicrocode = chipSetIsIntel;
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      ports = [ 22 ];
    };
  };

  systemd = {
    package = pkgs.systemd.override {
      withHomed = true;
    };
  };

  time.timeZone = lib.mkOverride 1000 "UTC";

}
