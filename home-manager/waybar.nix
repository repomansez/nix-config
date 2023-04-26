{ hyprland, ...}: {
	#enable = true;
	#systemd.enable = true;
	package = hyprland.packages."x86_64-linux".waybar-hyprland;
	settings = {
		options = {
			layer = "top";
			height = 24;
			
			"modules-left" = ["wlr/workspaces" "hyprland/window"];
			"modules-right" = ["cpu" "memory" "temperature" "clock" "tray"];
			
			"wlr/workspaces" = {
				on-click = "activate";
			};
		};
	};
	
	style = ./waybar/style.css;
}
