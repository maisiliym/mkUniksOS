{ pkgs, lib, hyraizyn, config, kor, revz, ... }:
let
  inherit (lib) mkOverride;

in
{
  boot = {
    supportedFilesystems = mkOverride 10 [ "btrfs" "vfat" "xfs" "ntfs" ];
  };

  isoImage = {
    isoBaseName = "uniksos";
    volumeID = "uniksos-${revz.uniksos}-${revz.nixos}-${pkgs.stdenv.hostPlatform.uname.processor}";

    makeUsbBootable = true;
    makeEfiBootable = true;
  };

}
