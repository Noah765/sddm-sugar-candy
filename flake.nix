{
  description = "Fork of the SDDM Sugar Candy theme by Marian Arlt";

  outputs = {self}: {
    nixosModules = rec {
      default = sddm-sugar-candy;

      sddm-sugar-candy = {
        lib,
        pkgs,
        config,
        ...
      }:
        with lib; let
          cfg = config.services.displayManager.sddm.sugarCandy;
        in {
          options.services.displayManager.sddm.sugarCandy = {
            enable = mkEnableOption "sugar candy";

            settings = mkOption {
              type = with types; attrsOf (oneOf [bool int float str path]);
              description = "The configuration for the SDDM Sugar Candy theme written in Nix.";
              example = {
                Background = /path/to/image.png;
                DimBackgroundImage = 0.5;
              };
            };
          };

          config = mkIf cfg.enable {
            assertions = [
              {
                assertion = config.services.displayManager.sddm.enable;
                message = "The SDDM Sugar Candy theme requires SDDM to be enabled.";
              }
            ];

            environment.systemPackages = [
              (pkgs.libsForQt5.callPackage ./default.nix {themeSettings.General = cfg.settings;})
            ];
            services.displayManager.sddm.theme = "sddm-sugar-candy";
          };
        };
    };
  };
}
