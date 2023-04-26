# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, hyprland, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
     #./nvim.nix
     #./waybar.nix 
  ];

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
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # Set your username
  home = {
    username = "nigerius";
    homeDirectory = "/home/nigerius";
  };
  # Font stuff ig
  fonts.fontconfig.enable = true;
  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [ vim git foot firefox tdesktop discord neofetch grim slurp fira-code wl-clipboard pipewire wireplumber rtkit kitty wofi fuzzel noto-fonts mononoki monocraft font-awesome_5];
  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
	enable = true;
	userName = "repomansez";
	userEmail = "sbctani@protonmail.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
  wayland.windowManager.hyprland = {
	enable = true;
	extraConfig = builtins.readFile ../dotfiles/extrahypr.conf;
  };
programs.waybar = {
      enable = true;
      package = hyprland.packages."x86_64-linux".waybar-hyprland;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 24;
          modules-left = [
            "wlr/workspaces"
	    "hyprland/window"
          ];
          modules-center = [
          ];
          modules-right =  [
            #"mpd"
          #  "wireplumber"
            "temperature"
            "cpu"
            "memory"
            "clock"
          ];
          "mpd" = {
            "format" = "  {artist} - {album} - {title} {stateIcon}";
            "format-disconnected" = "";
            "format-stopped" = "";
            "unknown-tag" = "N/A";
            "interval" = 2;
            "on-click" = "${pkgs.mpc-cli}/bin/mpc toggle";
            "on-click-right" = "${pkgs.mpc-cli}/bin/mpc stop";
            "state-icons" = {
              "paused" = "";
              "playing" = "";
            };
            "tooltip-format" = "MPD (connected)";
            "tooltip-format-disconnected" = "MPD (disconnected)";
          };
          "wlr/workspaces" = {
	    on-click = "activate";
            disable-scroll = true;
            all-outputs = false;
          };
          "cpu" = {
            "format" = " {usage}%";
            "tooltip" = true;
            "interval" = 2;
          };
          "temperature" = {
            "hwmon-path" = "/sys/class/hwmon/hwmon3/temp1_input";
            "critical-threshold" = 80;
            "inerval" = 1;
            "format" = " {temperatureC}°C";
            "format-critical" = " {temperatureC}°C";
          };
          "pulseaudio" = {
            "format" = "{icon} {volume}%";
            "format-muted" = "  muted";
            "format-icons" = {
              "headphone" = " ";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [" " " " " "];
            };
            "on-click" = "vol mute";
            "on-click-right" = "${pkgs.pavucontrol}/bin/pavucontrol";
          };
          "clock" = {
            "locale" = "pt_BR.UTF-8";
            "format" = " {:%H:%M}";
            "format-alt" = " {:%a %d %b %H:%M}";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
          };
          "memory" = {
            "format" = " {used:0.1f}G/{total:0.1f}G";
          };
        };
      };
};
}
