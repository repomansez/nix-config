# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
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
    ./dunst.nix
    #./mpd.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      (final: prev: {
        ass = inputs.xdph.packages.x86_64-linux;
      })
      (final: prev: {
        sixfourgram = pkgs.tdesktop.overrideAttrs (finalAttrs: previousAttrs: {
          src = pkgs.fetchFromGitHub {
            owner = "TDesktop-x64";
            fetchSubmodules = true;
            repo = "tdesktop";
            rev = "57c01bbfb18ce0a63fe86d7e998f4a9ad7356915";
            sha256 = "SlxFZTceKqeHe5GdDyS39U7UGSxrd/weoAjL496dEOE=";
          };
        });
      })
      (final: prev: {
        flameshot-notshit = pkgs.flameshot.overrideAttrs (finalAttrs: previousAttrs: {
          cmakeFlags = [
            "-DUSE_WAYLAND_GRIM=1"
          ];
          src = pkgs.fetchFromGitHub {
            owner = "repomansez";
            fetchSubmodules = true;
            repo = "flameshot";
            rev = "583e5dcddc9b6f8e70fa6a9069d64dbd74b3c97d";
            sha256 = "r81JZf5waFHY72eX/JkCY7rsNea9oTVtrs5PPDD9UWo=";
          };
        });
      })
      inputs.anyrun.overlay
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
    firefox
    webcord-vencord
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
    #dunst
    mpv
    inputs.hyprwm-contrib.packages.${system}.grimblast
    wine64
    lutris
    pkgs.anyrun
    nheko
    neochat
    xonotic
    sixfourgram
    killall
    wget
    obs-studio
    #inputs.xdph.packages.${system}.hyprland-share-picker
    #ass.hyprland-share-picker
    pkgs.hyprland-share-picker
    pcsx2
    rpcs3
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
    prismlauncher
    monocraft
    yt-dlp
    vscodium-fhs
    ungoogled-chromium
    flameshot-notshit
    gsettings-desktop-schemas
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
