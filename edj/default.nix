{ kor, hyraizyn, config, pkgs, lib, uyrld, ... }:
let
  inherit (kor) mkIf optional optionals optionalString optionalAttrs;
  inherit (lib) mkOverride;

  inherit (hyraizyn.astra.spinyrz) saizAtList;

  izX230 = hyraizyn.astra.mycin.modyl == "ThinkPad X230";
  izX240 = hyraizyn.astra.mycin.modyl == "ThinkPad X240";

  medPackages = optionals saizAtList.med (with pkgs; [ ]);
  maxPackages = optionals saizAtList.max (with pkgs; [ ]);

in
{
  hardware.pulseaudio.enable = false;

  environment = {
    systemPackages = [ ] ++ medPackages ++ maxPackages;

    gnome3.excludePackages = with pkgs.gnome3; [
      gnome-software
    ];
  };

  sound = {
    enable = true;
    extraConfig = "";
  };

  programs = {
    geary.enable = mkIf saizAtList.med (mkOverride 0 false); # force to disable keyring

    adb.enable = saizAtList.med;

    sway = {
      enable = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };

      extraSessionCommands = ''
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export GDK_BACKEND=wayland
      '';
    };
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };

    dbus.packages = mkIf saizAtList.med [ pkgs.gcr ];

    gnome3 = {
      gnome-initial-setup.enable = false;
      chrome-gnome-shell.enable = false;
      gnome-keyring.enable = mkOverride 10 false;
    };

    xserver = {
      enable = saizAtList.med;
      displayManager = {
        gdm = {
          enable = saizAtList.med;
          autoSuspend = true;
        };
      };

      desktopManager = {
        gnome3 = {
          enable = saizAtList.max;
          extraGSettingsOverrides = ''
            [org.gnome.desktop.peripherals.touchpad]
            tap-to-click=true
          '';
        };
      };

      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          tapping = true;
        };
      };

    };

    udisks2.enable = true;

    udev = {
      extraRules = ''
        ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", GROUP="dialout", MODE="0660"
      '';
    };
  };

  users.groups.dialout = { };

}
