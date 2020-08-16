{ kor, hyraizyn, pkgs, lib, ... }:
let
  inherit (kor) eksportJSON;
  inherit (lib) mkOverride;

  inherit (hyraizyn) astra;

  jsonHyraizynFail = eksportJSON "hyraizyn.json" hyraizyn;
  chipSetIsIntel = true; # TODO

in
{
  boot = {
    kernelParams = [ "consoleblank=300" ];

    kernelPackages = pkgs.linuxPackages_latest;

    supportedFilesystems = mkOverride 50 [ "xfs" "btrfs" ]; # TODO remove btrfs
  };

  environment.etc."hyraizyn.json" = {
    source = jsonHyraizynFail;
    mode = "0600";
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

}
