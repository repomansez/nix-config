# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, hyprland, hyprwm-contrib, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    inputs.hyprland.homeManagerModules.default
    #inputs.hyprland.nixosModules.default

    # You can also split up your configuration and import pieces of it here:
     #./nvim.nix
     ./waybar.nix 
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
  home.packages = with pkgs; [ vim git foot firefox tdesktop discord neofetch grim slurp fira-code wl-clipboard pipewire wireplumber rtkit kitty wofi fuzzel noto-fonts mononoki monocraft font-awesome_5 jellyfin-media-player breeze-qt5 breeze-gtk playerctl mpd mpdris2 libnotify dunst prismlauncher mpv 

#inputs.hyprwm-contrib.packages.${system}.grimblast 

];
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
}
