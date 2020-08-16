{
  description = "mkUniksOS";

  outputs =
    { self
    , kor
    , gluNixOS
    , mkIval
    }@fleiks:

    {
      datom = { hyraizyn, isoImydj ? false }:
        let
          kor = fleiks.kor.datom;
          inherit (kor) optional;

          revz = {
            nixos = gluNixOS.datom.nixosRev;
            uniksos = self.shortRev;
          };

          krimynzModule = import ./krimynz.nix;
          niksModule = import ./niks.nix;
          normylaizModule = import ./normylaiz.nix;
          neksisModule = import ./neksis;

          iuzIsoConfig = !iuzPodConfig && isoImydj ||
            (hyraizyn.astra.io.disks == { });

          iuzPodConfig = (hyraizyn.astra.mycin.spici == "pod");
          iuzMetylConfig = (hyraizyn.astra.mycin.spici == "metyl");

          disksModule =
            if iuzPodConfig
            then import ./pod.nix
            else if iuzIsoConfig
            then import ./liveIso.nix
            else import ./priInstyld.nix;

          metylModule = import ./metyl.nix;

          nixosConfigz = [
            krimynzModule
            disksModule
            niksModule
            normylaizModule
            neksisModule
          ] ++
          (optional iuzIsoConfig gluNixOS.datom.isoImageModule)
          ++
          (optional iuzMetylConfig metylModule);

          ival = mkIval.datom { inherit hyraizyn; };

          evalUniksOS = ival {
            iuzNixos = true;
            moduleArgz = { inherit revz; };
            modules = nixosConfigz;
          };

          bildUniksOSVM = evalUniksOS.config.system.build.vm;
          bildUniksOS = evalUniksOS.config.system.build.toplevel;
          bildUniksOSIso = evalUniksOS.config.system.build.isoImage;

        in
        if isoImydj then bildUniksOSIso
        else bildUniksOS;

    };
}
