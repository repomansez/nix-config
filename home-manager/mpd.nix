{
  pkgs,
  fetchFromGitHub,
  ...
}: {
  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      mpd = pkgs.mpd.override {
        src = fetchFromGitHub {
          owner = "MusicPlayerDaemon";
          repo = "MPD";
          rev = "99885c4cbcbb5545708104825cb56d67e20c4517";
          hash = "";
        };
      };
    };
  };
}
