{pkgs, ...}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Monocraft:size=11";
        dpi-aware = "yes";
      };
      colors = {
        alpha = 0.8;
      };
    };
  };
}
