{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.firefox;

in

{
  options = {
    programs.firefox = {
      commonProfileConfig = mkOption {
        type = types.submodule {
          options = {
            settings = mkOption {
              type = with types; attrsOf (either bool (either int str));
              default = {};
              example = literalExample ''
                {
                  "browser.startup.homepage" = "https://nixos.org";
                  "browser.search.region" = "GB";
                  "browser.search.isUS" = false;
                  "distribution.searchplugins.defaultLocale" = "en-GB";
                  "general.useragent.locale" = "en-GB";
                  "browser.bookmarks.showMobileBookmarks" = true;
                }
              '';
              description = "Attribute set of Firefox preferences.";
            };

            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                Extra preferences to add to <filename>user.js</filename>.
              '';
            };

            userChrome = mkOption {
              type = types.lines;
              default = "";
              description = "Custom Firefox CSS.";
              example = ''
                /* Hide tab bar in FF Quantum */
                @-moz-document url("chrome://browser/content/browser.xul") {
                  #TabsToolbar {
                    visibility: collapse !important;
                    margin-bottom: 21px !important;
                  }
                  #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
                    visibility: collapse !important;
                  }
                }
              '';
            };
          };
        };

        default = {};
        description = "Configuration to apply to all Firefox profiles.";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf config.profiles.gnome.enable {
      programs.firefox.package = pkgs.firefox-wayland;
    })

    {
      programs.firefox.commonProfileConfig = {
        settings = {
          "browser.tabs.drawInTitlebar" = true;
          "browser.uidensity" = 0;
          "extensions.pocket.enabled" = false;
          "svg.context-properties.content.enabled" = true;
          "toolkit.cosmeticAnimations.enabled" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "ui.key.menuAccessKey" = 0; # Hide access key underlining
        };

        userChrome = ''
          @import "/home/tad/proj/firefox-plata-theme/result/plata-theme.css";
          @import "/home/tad/proj/firefox-plata-theme/result/hide-single-tab.css";
          @import "/home/tad/proj/firefox-plata-theme/result/system-icons.css";
          @import "/home/tad/proj/firefox-plata-theme/result/drag-window-headerbar-buttons.css";
        '';
      };

      xdg.dataFile."applications/firefox.desktop".text = ''
        ${fileContents "${cfg.package}/share/applications/firefox.desktop"}
        Actions=NewWindow;NewPrivateWindow;${concatMapStrings (p: p.name + ";") (builtins.attrValues cfg.profiles)}
      '';
    }
  ]);
}
