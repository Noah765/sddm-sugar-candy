{
  stdenvNoCC,
  lib,
  qtgraphicaleffects,
  themeSettings,
}:
stdenvNoCC.mkDerivation {
  pname = "sddm-sugar-candy";
  version = "1.6";

  src = with lib.fileset;
    toSource {
      root = ./.;
      fileset = unions [
        ./Main.qml
        ./Components
        ./Assets
        ./theme.conf
        ./metadata.desktop
      ];
    };

  dontWrapQtApps = true;

  propagatedUserEnvPkgs = [qtgraphicaleffects];

  installPhase = let
    themeDir = "$out/share/sddm/themes/sddm-sugar-candy";
    settings = lib.generators.toINI {} themeSettings;
  in ''
    mkdir -p ${themeDir}
    cp -r . ${themeDir}
    echo "${settings}" > ${themeDir}/theme.conf.user
  '';
}
