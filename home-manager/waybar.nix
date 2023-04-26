{ pkgs, hyprland, ... }: {
programs.waybar = {
      enable = true;
      package = hyprland.packages."x86_64-linux".waybar-hyprland;
      "style" = ../dotfiles/style.css;
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
            "pulseaudio"
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
            "on-click" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
	   "on-scroll-up" = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%+";
	   "on-scroll-down" = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%-";
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
