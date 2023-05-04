# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  nixpkgsunst,
  lib,
  config,
  pkgs,
  hyprland,
  xdph,
  hyprwm-contrib,
  anyrun,
  fetchFromGitHub,
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
    ./foot.nix
    ./hyprpaper.nix
    #./mpd.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      (final: prev: {
        prismlauncher-git = pkgs.prismlauncher.overrideAttrs (finalAttrs: previousAttrs: {
          src = pkgs.fetchFromGitHub {
            owner = "PrismLauncher";
            fetchSubmodules = true;
            repo = "PrismLauncher";
            rev = "64ba5e4ed1456bed159cfe7b41ed9175b8baf5c4";
            sha256 = "6uN7nF52xCIWt4/YcxMRe5T5Zun7DXX9y6shrMwOTok=";
          };
        });
      })
      anyrun.overlay
      #  let
      #	(self: super: {
      # mpd = super.mpd.overrideAttrs (prev: {
      #version = "git";
      #   mesonFlags = [
      #     "-Dtest=true"
      #     "-Dmanpages=true"
      #     "-Dhtml_manual=true"
      #     "-Ddocumentation=disabled"
      #   ];
      #   src = pkgs.fetchFromGitHub {
      #     owner = "MusicPlayerDaemon";
      #        repo = "MPD";
      #        rev = "99885c4cbcbb5545708104825cb56d67e20c4517";
      #        sha256 = "BajG4d3hWkxFHQ8Xa1WbwLrEmFucKFUIinCrPuUNT1c=";
      #      };
      #  });
      #})
      #in
      #  nixpkgs.overlays = [ mpd_overlay ];
      # # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # Or define it inline, for example:
      # (final: prev: {
      #   prismlauncher = final.hello.prismlauncher (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      # Configure your nixpkgs instance
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Set your username
  home = {
    username = "mewi";
    homeDirectory = "/home/mewi";
  };
  fonts = {
    fontconfig.enable = true;
  };
  # Add stuff for your user as you see fit:
  # programs.neovim.enable o= true;
  home.packages = with pkgs; [
    vim
    git
    #foot
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
    font-awesome_5
    jellyfin-media-player
    libsForQt5.breeze-qt5
    libsForQt5.breeze-gtk
    libsForQt5.breeze-icons
    playerctl
    mpdris2
    libnotify
    dunst
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
    #inputs.nixpkgsunst.xdg-desktop-portal-hyprland
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
    python3
    hyprpaper
    udisks2
    xdg-user-dirs
    winetricks
    gamemode
    exa
    prismlauncher-git # temporary fix for meson bug
    monocraft
    yt-dlp
  ];
  # Enable home-manager and git
  # qt qt
  qt = {
    enable = true;
    style = {
      name = "Breeze-Dark";
      package = pkgs.breeze-qt5;
    };
  };
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
    cursorTheme = {
      name = "breeze_cursors";
      size = 24;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "repomansez";
    userEmail = "sbctani@protonmail.com";
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "exa --color-scale --sort=type --group-directories-first";
      rm = "rm -i";
      mv = "mv -i";
      e = "hx";
      vim = "hx";
    };
    initExtra = ''
      ix() { curl -F f:1='<-' ix.io < "$*"; }

      0x0() {
      for i in "$@"; do
      	curl -F file=@$i http://0x0.st
      done
      }

      repeat() {
      	while :; do
      		"$@"
      	done
      }

      hyprlog() {
      	case $* in
      		l) cat "/tmp/hypr/$(/bin/ls -t /tmp/hypr/ | head -n 2 | tail -n 1)/hyprland.log";;
      		*) cat "/tmp/hypr/$(/bin/ls -t /tmp/hypr/ | head -n 1)/hyprland.log";;
      	esac
      }
    '';
  };
  services.mpd = {
    enable = true;
    #musicDirectory = "nfs://10.0.0.24/home/sex/data/music/";
    musicDirectory = "/home/mewi/nfs/data/music";
    dbFile = "/home/mewi/.local/share/mpd/database";
    extraConfig = ''
      audio_output {
         type "pipewire"
         name "piss"
         }'';
  };
  services.mpdris2 = {
    enable = true;
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
  home.sessionVariables = {
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    #SDL_VIDEODRIVER = "x11";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    WLR_NO_HARDWARE_CURSORS = "1";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../dotfiles/extrahypr.conf;
  };
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      startup = [
        {command = "firefox";}
      ];
    };
  };

  #package = inputs.hyprland.hyprland;
  #xwayland.enable = true;
  #extraConfig = builtins.readFile ../dotfiles/extrahypr.conf;
  #};
}
