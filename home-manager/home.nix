# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  hyprland,
  xdph,
  #hyprwm-contrib,
  anyrun,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    inputs.hyprland.homeManagerModules.default
    #inputs.hyprland.nixosModules.default

    # You can also split up your configuration and import pieces of it here:
    #./nvim.nix
    ./waybar.nix
    ./anyrun.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      anyrun.overlay
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
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Set your username
  home = {
    username = "nigerius";
    homeDirectory = "/home/nigerius";
  };
  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    vim
    git
    foot
    firefox
    discord
    neofetch
    grim
    slurp
    fira-code
    wl-clipboard
    pipewire
    wireplumber
    rtkit
    kitty
    wofi
    fuzzel
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    mononoki
    monocraft
    font-awesome_5
    jellyfin-media-player
    libsForQt5.breeze-qt5
    libsForQt5.breeze-gtk
    libsForQt5.breeze-icons
    playerctl
    mpd
    mpdris2
    libnotify
    dunst
    prismlauncher
    mpv
    inputs.hyprwm-contrib.packages.${system}.grimblast
    wine
    lutris
    pkgs.anyrun
    nheko
    neochat
    xonotic
    tdesktop
    killall
    wget
    obs-studio
    xdg-desktop-portal-hyprland
    inputs.xdph.packages.${system}.hyprland-share-picker
    pcsx2
    rpcs3
    chromium
    konversation
    kde-gtk-config
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.kio
    libsForQt5.kio-extras
    ffmpegthumbnailer
    libsForQt5.ffmpegthumbs
    ncmpcpp
    mpc-cli
  ];
  # Enable home-manager and git
  # qt qt
  # qt = {
  #   enable = true;
  #   style = {
  #     name = "breeze";
  #     package = pkgs.breeze-qt5;
  #   };
  #   platformTheme = "kde";
  # };
  # gtkaka
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.breeze-icons;
      name = "breeze-dark";
    };
    theme = {
      package = pkgs.breeze-gtk;
      name = "Breeze-Dark";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  #gtk = {
  #  enable = true;
  #  theme = {
  #    name = "breeze-gtk";
  #    package = pkgs.breeze-gtk;
  #  };
  #  iconTheme = {
  #    name = "breeze";
  #    package = pkgs.breeze-icons;
  #  };
  #};
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "repomansez";
    userEmail = "sbctani@protonmail.com";
  };

  services.mpd = {
    enable = true;
    package = inputs.spkgs.mpd;
    #musicDirectory = "nfs://10.0.0.24/home/sex/data/music/";
    musicDirectory = "/home/nigerius/nfs-music";
    dbFile = "/home/nigerius/.local/share/mpd/database";
    extraConfig = ''
     audio_output {
        type "pipewire"
        name "piss"
        }'';
  };
  services.mpdris2 = {
    enable = false;
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = builtins.readFile ../dotfiles/extrahypr.conf;
  };
}
