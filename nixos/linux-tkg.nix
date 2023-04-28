{pkgs, ...}: {
  boot.kernelPackages = let
    linux_tkg_pkg = {
      fetchurl,
      buildLinux,
      ...
    } @ args:
      buildLinux (args
        // rec {
          version = "6.3.0";
          modDirVersion = version;

          src = fetchurl {
            url = "https://github.com/repomansez/linux-tkg-nix/releases/download/6.3.0/linux-tkg-6.3.0.tar.gz";
            sha256 = "d6d5e9cd49e41d27c94f85fce7817d228b6866e76c990a0af873ee4f38bc5eeb";
          };
          kernelPatches = [];

          extraConfig = ''
          '';

          #extraMeta.branch = "6.3.0";
        }
        // (args.argsOverride or {}));
    linux_tkg = pkgs.callPackage linux_tkg_pkg {};
  in
    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_tkg);
}
