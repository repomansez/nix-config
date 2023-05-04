# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  buildPackages,
  buildLinux,
  fetchurl,
  perl,
  nixosTests,
  config,
  pkgs,
  hyprland,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hyprland.nixosModules.default
    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    #    ./linux-tkg.nix
  ];
  # Querneuli
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Some tkg patches
  boot.kernelPatches = [
    {
      patch = ./kernelpatches/0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch;
      patch1 = ./kernelpatches/0002-clear-patches.patch;
      patch2 = ./kernelpatches/0007-v6.3-fsync1_via_futex_waitv.patch;
      patch3 = ./kernelpatches/0007-v6.3-winesync.patch;
      patch5 = ./kernelpatches/0009-prjc_v6.3-r0.patch;
      patch6 = ./kernelpatches/0009-glitched-bmq.patch;
      patch7 = ./kernelpatches/0012-misc-additions.patch;
      patch8 = ./kernelpatches/0013-optimize_harder_O3.patch;
    }
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-c28f4828-a1aa-4b10-96ae-1dffc24a460e".device = "/dev/disk/by-uuid/c28f4828-a1aa-4b10-96ae-1dffc24a460e";
  boot.initrd.luks.devices."luks-c28f4828-a1aa-4b10-96ae-1dffc24a460e".keyFile = "/crypto_keyfile.bin";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
  # Extra filesystems
  fileSystems."/home/mewi/nfs" = {
    device = "10.0.0.24:/home/sex";
    fsType = "nfs";
    options = ["nfsvers=4.2"];
  };
  # RTkit and pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # so dolphin doesnt take ages to start
  services.udisks2.enable = true;
  environment.sessionVariables = rec {
    QT_STYLE_OVERRIDE = "kvantum";
  };
  environment.systemPackages = with pkgs; [
    vim
    git
    rtkit
    pipewire
    wireplumber
    glxinfo
    virtualgl
    pciutils
    libglvnd
    mesa
    vulkan-tools
    gamescope
    mangohud
    xwayland
    libkrb5
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXScrnSaver
    libpng
    libpulseaudio
    libvorbis
    stdenv.cc.cc.lib
    libkrb5
    keyutils
    e2fsprogs
    corectrl
    guitarix
    gxplugins-lv2
    pipewire.jack
    helix
    vulkan-headers
    foot
  ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mewi = {
    isNormalUser = true;
    description = "repomansez";
    extraGroups = ["networkmanager" "wheel" "input"];
    packages = with pkgs; [git vim home-manager];
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      nixpkgs.config.packageOverrides = pkgs: {
        #       xdg-desktop-portal-hyprland = inputs.xdph.packages.${prev.system}.default.override {
        # hyprland-share-picker = inputs.xdph.packages.${prev.system}.hyprland-share-picker.override {inherit hyprland;};
        #};

        steam = pkgs.steam.override {
          extraPkgs = pkgs:
            with pkgs; [
              xdg-user-dirs
              gamescope
              xwayland
              dconf
              mangohud
              libgdiplus
              zulu
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              libkrb5
              keyutils
              e2fsprogs
              gst_all_1.gst-vaapi
              gst_all_1.gstreamer
              gst_all_1.gst-plugins-ugly
              gst_all_1.gst-plugins-bad
              gst_all_1.gst-plugins-good
            ];
        };
      };
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # FIXME: Add the rest of your current configuration

  #  Set your hostname
  networking.hostName = "nixos";
  networking.nameservers = ["1.1.1.1" "9.9.9.9"];
  # Policykit
  security.polkit.enable = true;
  # Font shit ig
  #qt = {
  #  enable = true;
  #  style = {
  #    name = "Breeze-Dark";
  #    package = pkgs.breeze-qt5;
  #  };
  #  platformTheme = "kde";
  #};
  #gtk = {
  #  enable = true;
  #  iconTheme = {
  #    package = pkgs.breeze-icons;
  #    name = "breeze-dark";
  #  };
  #  theme = {
  #    package = pkgs.breeze-gtk;
  #    name = "Breeze-Dark";
  #  };
  #  gtk4.extraConfig = {
  #    gtk-application-prefer-dark-theme = true;
  #  };
  #};
  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      antialias = true;
    };
    fonts = with pkgs; [
      fira-code
      mononoki
      inputs.nixpkgsunst.legacyPackages.x86_64-linux.monocraft
      font-awesome_5
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };
  # This is just an example, be sure to use whatever bootloader you prefer
  # boot.loader.systemd-boot.enable = true;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  #  programs.hyprland = {
  #    enable = true;
  #    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #  };

  services.tor = {
    enable = true;
    client.enable = true;
  };
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    #    openssh.settings.permitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    #    openssh.settings.passwordAuthentication = false;
  };
  xdg.portal = with pkgs; {
    enable = true;
    wlr.enable = true;
    extraPortals = [inputs.xdph.packages.x86_64-linux.xdg-desktop-portal-hyprland];
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      inputs.nixpkgsunst.legacyPackages.x86_64-linux.mesa
      pkgs.mesa.drivers
      rocm-opencl-icd
      rocm-opencl-runtime
      vulkan-loader
      vulkan-tools
    ];
  };
  programs.steam = {
    enable = true;
  };
  programs.sway.enable = true;
  programs.dconf.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.videoDrivers = ["amdgpu"];
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
