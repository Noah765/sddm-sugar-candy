{
  description = "Fork of the SDDM Sugar Candy theme by Marian Arlt";

  outputs =
    { self }:
    {
      nixosModules = rec {
        default = sddm-sugar-candy;
        sddm-sugar-candy =
          {
            lib,
            pkgs,
            config,
            ...
          }:
          {
            options.services.displayManager.sddm.sugarCandy.settings = lib.mkOption {
              type =
                with lib.types;
                attrsOf (oneOf [
                  bool
                  int
                  float
                  str
                  path
                ]);
              description = "The configuration for the SDDM Sugar Candy theme written in Nix.";
              example = ''
                {
                  Background = /path/to/image.png;
                  DimBackgroundImage = 0.5;
                }
              '';
            };

            config = {
              assertions = [
                {
                  assertion = config.services.displayManager.sddm.enable;
                  message = "The SDDM Sugar Candy theme requires SDDM to be enabled.";
                }
              ];

              environment.systemPackages = [
                (pkgs.libsForQt5.callPackage ./default.nix {
                  themeSettings.General = config.services.displayManager.sddm.sugarCandy.settings;
                })
              ];
              services.displayManager.sddm.theme = "sddm-sugar-candy";
            };
          };
      };
    };
}
