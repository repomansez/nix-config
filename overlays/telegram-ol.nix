self: super:
{
  telegram-desktop = super.telegram-desktop.overrideAttrs ( old {
    src = super.fetchFromGitHub {
      owner = "telegramdesktop";
      repo = "tdesktop";
      rev = "v4.8.0";
      fetchSubmodules = true;
      hash = "";
    };
  };
}
