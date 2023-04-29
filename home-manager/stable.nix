{ config, pkgs, ...}:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixos-22.11> { config = baseconfig; };
in {

  services.mpd = {
    enable = true;
    package = unstable.mpd;
    #musicDirectory = "nfs://10.0.0.24/home/sex/data/music/";
    musicDirectory = "/home/nigerius/nfs-music";
    dbFile = "/home/nigerius/.local/share/mpd/database";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "piss"
        }'';
  };
 # environment.systemPackages = with pkgs; [
 #   unstable.google-chrome
  #];
}
